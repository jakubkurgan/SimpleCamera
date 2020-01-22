//
//  ApplicationConstants.swift
//  SimpleCamera
//
//  Created by Jakub Kurgan on 22/01/2020.
//  Copyright © 2020 Jakub Kurgan. All rights reserved.
//

import Foundation

enum ApplicationConstants {
    enum UploadConfig {
        static let baseUrl = URL(string: "https://Jakubkurgan.pythonanywhere.com")!
        static let uploadPath = "/upload"
    }
    
    enum DetectionConfig {
        static let baseUrl = URL(string: "https://face-detection6.p.rapidapi.com")!
        static let faceAgeGenderPath = "/img/face-age-gender"
        static let host = "face-detection6.p.rapidapi.com"
        static let key = "c8f9a205d4mshdf2ac33ef4cc89dp149f5ajsn95761c1d1e9c"
        static let contentType = "application/json"
        static let accept = "application/json"
    }
}
