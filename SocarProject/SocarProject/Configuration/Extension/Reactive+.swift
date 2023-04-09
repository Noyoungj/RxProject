//
//  Reactive+.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/12.
//

import RxSwift

extension Reactive where Base: MTMapView {
    
}

extension Reactive where Base: MapViewController {
    var addPOIItems: Binder<[ZonesEntity]> {
        return Binder(base) { base, zones in
            let items = zones
                .enumerated()
                .map { offset, zone -> MTMapPOIItem in
                    let mapPOIItem = MTMapPOIItem()
                    mapPOIItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: zone.point.0, longitude: zone.point.1))
                    mapPOIItem.markerType = .customImage
                    mapPOIItem.customImage = UIImage(named: "img_zone_shadow")
                    mapPOIItem.tag = Int(zone.id!) ?? 0
                    return mapPOIItem
                }
            
            base.mapView.removeAllPOIItems()
            base.mapView.addPOIItems(items)
        }
    }
    
    var initialMapPoint: Binder<(MTMapPoint, Bool)> {
        return Binder(base) { base, mapPoint in
            base.mapView.setMapCenter(mapPoint.0, zoomLevel: 2, animated: mapPoint.1)
        }
    }
    var setMapCenterPoint: Binder<(MTMapPoint, Bool)> {
        return Binder(base) { base, point in
            base.mapView.setMapCenter(point.0, animated: point.1)
        }
    }
}
