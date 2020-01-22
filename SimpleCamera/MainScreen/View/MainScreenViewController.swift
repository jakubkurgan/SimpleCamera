//
//  MainScreenViewController.swift
//  SimpleCamera
//
//  Created by Jakub Kurgan on 21/01/2020.
//  Copyright © 2020 Jakub Kurgan. All rights reserved.
//

import UIKit

protocol MainScreenViewProtocol: class {
    func drawDetectedFaces(_ detectedFaces: [DetectedFace])
    func showMessage(from error: Error)
    func showLoadingIndicator(with title: String)
    func hideLoadingIndicator()
}

class MainScreenViewController: UIViewController {
    
    // MARK: - UI Components
    
    lazy var faceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(systemName: "camera.circle.fill", withConfiguration: UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 60))), for: .normal)
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(cameraCameraTapped(_:)), for: .touchDown)
        button.isUserInteractionEnabled = true
        button.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        return button
    }()
    
    lazy var galleryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.2.square.stack", withConfiguration: UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 60))), for: .normal)
        
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(galleryButtonTapped(_:)), for: .touchDown)
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    lazy var loadingIndicator: LoadingIndicatorView = {
        let view = LoadingIndicatorView(frame: self.view.bounds)
        self.view.addSubview(view)
        
        return view
    }()
    
    // MARK: - Properties
    
    private var presenter: MainScreenPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainScreenPresenter(view: self)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        setupFaceImageViewLayout()
        setupGalleryButtonLayout()
        setupCameraButtonLayout()
    }
    
    private func setupFaceImageViewLayout() {
        view.addSubview(faceImageView)
        
        NSLayoutConstraint.activate([
            faceImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            faceImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            faceImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            faceImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupGalleryButtonLayout() {
        view.addSubview(galleryButton)
        
        NSLayoutConstraint.activate([
            galleryButton.bottomAnchor.constraint(equalTo: faceImageView.bottomAnchor, constant: -30),
            galleryButton.trailingAnchor.constraint(equalTo: faceImageView.centerXAnchor, constant: -30)
        ])
    }
    
    private func setupCameraButtonLayout() {
        view.addSubview(cameraButton)
        
        NSLayoutConstraint.activate([
            cameraButton.bottomAnchor.constraint(equalTo: faceImageView.bottomAnchor, constant: -30),
            cameraButton.leadingAnchor.constraint(equalTo: faceImageView.centerXAnchor, constant: 30)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func galleryButtonTapped(_ button: UIButton) {
        presentPhotoPicker(sourceType: .photoLibrary)
    }
    
    @objc private func cameraCameraTapped(_ button: UIButton) {
        presentPhotoPicker(sourceType: .camera)
    }
    
    private func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        
        clearResults()
        present(picker, animated: true)
    }
    
    private func clearResults() {
        self.faceImageView.subviews.forEach { $0.removeFromSuperview() }
    }
}

extension MainScreenViewController: MainScreenViewProtocol {
    func showLoadingIndicator(with title: String) {
        loadingIndicator.active(with: title)
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.deactivate()
    }
    
    func showMessage(from error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    func drawDetectedFaces(_ detectedFaces: [DetectedFace]) {
        for detection in detectedFaces {
            guard let faceRect = getFaceRect(from: detection.boundingBox) else { return }
            
            let faceLabel = prepareFaceLabel(from: faceRect, detectedFace: detection)
            
            self.faceImageView.addSubview(faceLabel)
        }
    }
    
    private func getFaceRect(from boundingBox: BoundingBox) -> CGRect? {
        guard let imageSize = faceImageView.image?.size else {
            return nil
        }
        
        let x = (CGFloat(boundingBox.startX) / imageSize.width) * self.faceImageView.bounds.width
        let y = (CGFloat(boundingBox.startY) / imageSize.height) * self.faceImageView.bounds.height
        let xEnd = (CGFloat(boundingBox.endX) / imageSize.width) * self.faceImageView.bounds.width
        let yEnd = (CGFloat(boundingBox.endY) / imageSize.height) * self.faceImageView.bounds.height
        let width = xEnd - x
        let height = yEnd - y
        let rect = CGRect(x: x,
                          y: y,
                          width: width,
                          height: height)
        return rect
    }
    
    private func prepareFaceLabel(from rect: CGRect, detectedFace: DetectedFace) -> UILabel {
        let label = UILabel(frame: rect)
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "\(detectedFace.gender.gender)\n\(detectedFace.age.ageRange.low) - \(detectedFace.age.ageRange.high)"
        label.textColor = UIColor.red
        label.numberOfLines = 0
        label.isHidden = false
        label.backgroundColor = .clear
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.red.cgColor
        label.textAlignment = .center
        
        return label
    }
}

extension MainScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let photo = info[.originalImage] as! UIImage
        faceImageView.image = photo
        
        guard let photoData = photo.jpegData(compressionQuality: 1) else {
            return
        }
        
        presenter?.uploadPhotoAndMakeDetection(for: photoData)
    }
}
