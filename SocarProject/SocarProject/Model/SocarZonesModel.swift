//
//  socarZones.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/11.
//

import Foundation

struct SocarZonesModel : Decodable {
    var id : String?
    var name: String?
    var alias : String?
    var location : ZonesLocation?
}

struct ZonesLocation : Decodable {
    var lat : Double
    var lng : Double
}
