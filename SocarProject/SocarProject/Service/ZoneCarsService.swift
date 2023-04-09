//
//  ZoneCarsService.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/12.
//

import Foundation
import Moya
import RxSwift

protocol ZoneCarsServiceProtocol {
    func requestCars(_ id: String, completion: @escaping((Error?, [ZoneHaveCarsModel]?) -> Void))
}

class ZoneCarsService : ZoneCarsServiceProtocol {
    func requestCars(_ id : String,completion: @escaping((Error?, [ZoneHaveCarsModel]?) -> Void)) {
        let provider = MoyaProvider<MainAPI>()
        provider.request(.zoneCars(id)) { result in
            switch result {
            case let .success(response):
                let result = try? response.map([ZoneHaveCarsModel].self)
                completion(nil, result)
            case let .failure(error):
                print("API ERROR: \(error.localizedDescription)")
                completion(error, nil)
            }
        }
    }
}

