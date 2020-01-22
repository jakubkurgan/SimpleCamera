//
//  UploadModel.swift
//  SimpleCamera
//
//  Created by Jakub Kurgan on 22/01/2020.
//  Copyright © 2020 Jakub Kurgan. All rights reserved.
//

import Foundation
import Moya

// MARK: - Upload

struct UploadModel {
    static func uploadPhoto(_ photoData: Data, completion: ((Result<UploadedPhoto, Error>) -> Void)? ) {
        let provider = MoyaProvider<UploadNetworkLayer>()
        
        provider.request(.uploadPhoto(photoData)) { (result) in
            switch result {
                
            case .success(let response):
                let decoder = JSONDecoder()
                
                do {
                    let photo = try decoder.decode(UploadedPhoto.self, from: response.data)
                    completion?(.success(photo))
                } catch {
                    completion?(.failure(error))
                }
                
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}

struct UploadedPhoto: Codable {
    let url: String
}
