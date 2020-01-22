//
//  DetectionNetworkLayer.swift
//  SimpleCamera
//
//  Created by Jakub Kurgan on 22/01/2020.
//  Copyright © 2020 Jakub Kurgan. All rights reserved.
//

import Foundation
import Moya

enum DetectionNetworkLayer {
    case getDetection(uploadedPhoto: UploadedPhoto)
}

extension DetectionNetworkLayer: TargetType {
  public var baseURL: URL {
    return ApplicationConstants.DetectionConfig.baseUrl
  }
  
  public var path: String {
      return ApplicationConstants.DetectionConfig.faceAgeGenderPath
  }
  
  public var method: Moya.Method {
      return .post
  }
  
  public var sampleData: Data {
      return Data()
  }
  
  public var headers: [String : String]? {
      return [
          "x-rapidapi-host": ApplicationConstants.DetectionConfig.host,
          "x-rapidapi-key": ApplicationConstants.DetectionConfig.key,
          "content-type": ApplicationConstants.DetectionConfig.contentType,
          "accept": ApplicationConstants.DetectionConfig.accept
      ]
  }

    public var task: Task {
        switch self {
        case let .getDetection(uploadedPhoto):
            return .requestCustomJSONEncodable(uploadedPhoto, encoder: JSONEncoder())
        }
    }
}
