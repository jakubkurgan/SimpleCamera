//
//  DetectionMode.swift
//  SimpleCamera
//
//  Created by Jakub Kurgan on 21/01/2020.
//  Copyright © 2020 Jakub Kurgan. All rights reserved.
//

import Foundation
import Moya

// MARK: - Detection

struct DetectionModel {
    static func getDetection(for uploadedPhoto: UploadedPhoto, completion: ((Result<Detection, Error>) -> Void)?) {
        let provider = MoyaProvider<DetectionNetworkLayer>()
        
        provider.request(.getDetection(uploadedPhoto: uploadedPhoto)) { (result) in
            switch result {
                
            case .success(let response):
                let decoder = JSONDecoder()
                
                do {
                    let detection = try decoder.decode(Detection.self, from: response.data)
                    completion?(.success(detection))
                } catch {
                    completion?(.failure(error))
                }
                
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}

struct Detection: Codable {
    let detectedFaces: [DetectedFace]
    
    enum CodingKeys: String, CodingKey {
        case detectedFaces = "detected_faces"
    }
}

// MARK: - DetectedFace

struct DetectedFace: Codable {
    let boundingBox: BoundingBox
    let gender: Gender
    let age: Age
    
    enum CodingKeys: String, CodingKey {
        case boundingBox = "BoundingBox"
        case gender = "Gender"
        case age = "Age"
    }
}

// MARK: - Age

struct Age: Codable {
    let ageRange: AgeRange
    
    enum CodingKeys: String, CodingKey {
        case ageRange = "Age-Range"
    }
}

// MARK: - AgeRange

struct AgeRange: Codable {
    let low, high: Int
    
    enum CodingKeys: String, CodingKey {
        case low = "Low"
        case high = "High"
    }
}

// MARK: - BoundingBox

struct BoundingBox: Codable {
    let startX, startY, endX, endY: Int
    let probability: Double
    
    enum CodingKeys: String, CodingKey {
        case startX, startY, endX, endY
        case probability = "Probability"
    }
}

// MARK: - Gender

struct Gender: Codable {
    let gender: String
    let probability: Double
    
    enum CodingKeys: String, CodingKey {
        case gender = "Gender"
        case probability = "Probability"
    }
}
