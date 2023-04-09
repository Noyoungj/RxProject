//
//  MapViewModel.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/11.
//

import Foundation
import RxSwift
import RxCocoa

final class MapViewModel {
    
    //MARK: Properties
    private let zonesService : ZonesServiceProtocol
    
    let setMapCenter: Signal<(MTMapPoint, Bool)>
    let errorMessage: Signal<(MTMapPoint, Bool)>

    let currentLocation = PublishRelay<(MTMapPoint, Bool)>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let mapCenterPoint = PublishRelay<(MTMapPoint, Bool)>()
    let mapViewError = PublishRelay<(MTMapPoint, Bool)>()
    
    // 기본 위치 저장: 서울숲역
    var latitude = 37.54330366639085
    var longitude = 127.04455548501139
    
    let disposeBag = DisposeBag()
    
    //MARK: LifeCycle
    init(zonesService: ZonesServiceProtocol) {
        self.zonesService = zonesService
        
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation)
        
        let currentMapCenter = Observable.merge(mapCenterPoint.asObservable() ,currentLocation.take(1), moveToCurrentLocation)
        
        setMapCenter = currentMapCenter.asSignal(onErrorSignalWith: .empty())
        
        errorMessage = Observable.merge(mapViewError.asObservable()).asSignal(onErrorJustReturn: (MTMapPoint(geoCoord: MTMapPointGeo(latitude: self.latitude, longitude: self.longitude)), true))
    }
    
    func fetchData(_ zoneEntity : [ZonesEntity], _ zoneId: String, completion: @escaping((String, String, String) -> Void)) {
        let zoneEntity = zoneEntity.filter{ $0.id == zoneId }[0]
        mapCenterPoint.accept((MTMapPoint(geoCoord: MTMapPointGeo(latitude: zoneEntity.point.0, longitude: zoneEntity.point.1)), false))
        completion(zoneEntity.id ?? "", zoneEntity.name ?? "", zoneEntity.alias ?? "")
    }

    func fetchsZones() -> Observable<[ZonesEntity]> {
        return zonesService.fetchZones().map{ $0.map{ ZonesEntity(zones: $0)}}
    }
    
    
}

