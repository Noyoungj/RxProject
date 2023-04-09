//
//  MainAPI.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/11.
//

import Moya
import Foundation

enum MainAPI {
    case zones
    case zoneCars(_ id : String)
}

extension MainAPI : TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:3000")!
    }
    
    var path: String {
        switch self {
        case .zones:
            return "/zones"
        case .zoneCars:
            return "/cars"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .zones, .zoneCars:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .zones:
            return .requestPlain
        case .zoneCars(let zoneId):
            let parameters : [String : String] = [
                "zones_like" : zoneId
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
