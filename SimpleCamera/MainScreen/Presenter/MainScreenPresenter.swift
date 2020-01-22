//
//  MainScreenPresenter.swift
//  SimpleCamera
//
//  Created by Jakub Kurgan on 21/01/2020.
//  Copyright © 2020 Jakub Kurgan. All rights reserved.
//

import Foundation

protocol MainScreenPresenterProtocol {
    func uploadPhotoAndMakeDetection(for photoData: Data)
}

class MainScreenPresenter {
    
    // MARK: - Properties
    
    private weak var view: MainScreenViewProtocol?
    
    // MARK: - Lifecycle
    
    init(view: MainScreenViewProtocol?) {
        self.view = view
    }
}

extension MainScreenPresenter: MainScreenPresenterProtocol {
    func uploadPhotoAndMakeDetection(for photoData: Data) {
        uploadPhoto(photoData)
    }
    
    func getDetection(for uploadedPhoto: UploadedPhoto) {
        view?.showLoadingIndicator(with: "Detecting...")
        DetectionModel.getDetection(for: uploadedPhoto) { [weak self] (detectionResult) in
            self?.view?.hideLoadingIndicator()
            switch detectionResult {
            case .success(let detection):
                print(detection)
                self?.view?.drawDetectedFaces(detection.detectedFaces)
            case .failure(let error):
                self?.view?.showMessage(from: error)
            }
        }
    }
    
    func uploadPhoto(_ photoData: Data) {
        view?.showLoadingIndicator(with: "Uploading...")
        UploadModel.uploadPhoto(photoData) { [weak self] (uploadResult) in
            self?.view?.hideLoadingIndicator()
            switch uploadResult {
            case .success(let uploadedPhoto):
                self?.getDetection(for: uploadedPhoto)
            case .failure(let error):
                self?.view?.showMessage(from: error)
            }
        }
    }
}
