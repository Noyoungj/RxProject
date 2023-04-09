//
//  ZonesService.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/11.
//

import Foundation
import Moya
import RxSwift

protocol ZonesServiceProtocol {
    func fetchZones() -> Observable<[SocarZonesModel]>
}

final class ZonesService : ZonesServiceProtocol {
    func fetchZones() -> Observable<[SocarZonesModel]> {
        return Observable.create{ observer -> Disposable in
            self.fetchZones { error, zones in
                if let error = error {
                    observer.onError(error)
                }
                
                if let zones = zones {
                    observer.onNext(zones)
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    private func fetchZones(completion: @escaping((Error?, [SocarZonesModel]?) -> Void)) {
        let provider = MoyaProvider<MainAPI>()
        provider.request(.zones) { result in
            switch result {
            case let .success(response):
                let result = try? response.map([SocarZonesModel].self)
                completion(nil, result)
            case let .failure(error):
                print("API ERROR: \(error.localizedDescription)")
                completion(error, nil)
            }
        }
    }
}

