//
//  ZonesViewModel.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/12.
//

import Foundation

struct ZonesEntity {
    private let zones : SocarZonesModel
    
    var id : String? {
        return zones.id
    }
    
    var name : String? {
        return zones.name
    }
    
    var alias: String? {
        return zones.alias
    }
    
    var point: (Double, Double) {
        return (zones.location?.lat ?? 0, zones.location?.lng ?? 0)
    }
    
    init(zones: SocarZonesModel) {
        self.zones = zones
    }
}
