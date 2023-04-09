//
//  FavoriteZoneEntity.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/14.
//

import RealmSwift

final class FavoriteZoneEntity : Object {
    @objc dynamic var zoneId = ""
    @objc dynamic var zoneName = ""
    @objc dynamic var zoneAlies = ""
}
