//
//  ZoneCarsEntity.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/12.
//

import Foundation

struct ZoneCarsEntity {
    private let cars : ZoneHaveCarsModel
    
    var id : String? {
        return cars.id
    }
    
    var name : String? {
        return cars.name
    }
    
    var description: String? {
        return cars.description
    }
    
    var imageUrl : String? {
        return cars.imageUrl
    }
    
    var category: String? {
        return cars.category
    }
    
    
    init(cars: ZoneHaveCarsModel) {
        self.cars = cars
    }
}
