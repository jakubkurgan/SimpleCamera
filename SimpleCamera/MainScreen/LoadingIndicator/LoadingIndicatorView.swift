//
//  LoadingIndicatorView.swift
//  SimpleCamera
//
//  Created by Jakub Kurgan on 22/01/2020.
//  Copyright © 2020 Jakub Kurgan. All rights reserved.
//

import UIKit

class LoadingIndicatorView: UIView {
    
    // MARK: - UI Components
    
    lazy var loadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray2.withAlphaComponent(0.7)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        view.color = .systemOrange
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemOrange
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupLoadingViewLayout()
        setupActivityIndicatorViewLayout()
        setupTitleLabelLayout()
    }
    
    private func setupLoadingViewLayout() {
        addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 180),
            loadingView.widthAnchor.constraint(equalToConstant: 180),
        ])
    }
    
    private func setupActivityIndicatorViewLayout() {
        loadingView.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicatorView.heightAnchor.constraint(equalTo: loadingView.heightAnchor, multiplier: 0.5),
            activityIndicatorView.widthAnchor.constraint(equalTo: loadingView.widthAnchor, multiplier: 0.5),
        ])
    }
    
    private func setupTitleLabelLayout() {
        loadingView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: -2),
            titleLabel.bottomAnchor.constraint(equalTo: loadingView.bottomAnchor, constant: -2)
        ])
    }
    
    func active(with title: String) {
        titleLabel.text = title
        activityIndicatorView.startAnimating()
        isHidden = false
    }
    
    func deactivate() {
        titleLabel.text = ""
        activityIndicatorView.stopAnimating()
        isHidden = true
    }
}
