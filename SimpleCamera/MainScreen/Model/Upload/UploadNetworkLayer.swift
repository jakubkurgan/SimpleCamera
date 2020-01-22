//
//  UploadNetworkLayer.swift
//  SimpleCamera
//
//  Created by Jakub Kurgan on 22/01/2020.
//  Copyright © 2020 Jakub Kurgan. All rights reserved.
//

import Foundation
import Moya

enum UploadNetworkLayer {
    case uploadPhoto(_ photoData: Data)
}

extension UploadNetworkLayer: TargetType {
  public var baseURL: URL {
    return ApplicationConstants.UploadConfig.baseUrl
  }
  
  public var path: String {
      return ApplicationConstants.UploadConfig.uploadPath
  }
  
  public var method: Moya.Method {
      return .post
  }
  
  public var sampleData: Data {
      return Data()
  }
  
  public var headers: [String : String]? {
      return [:]
  }

    public var task: Task {
        switch self {
        case let .uploadPhoto(data):
            let name = "file"
            let fileName = name + UUID().uuidString + ".jpg"
            
            let photoData = MultipartFormData(provider: .data(data),
                                              name: name,
                                              fileName: fileName,
                                              mimeType: "image/jpg")

            return .uploadMultipart([photoData])
        }
    }
}
