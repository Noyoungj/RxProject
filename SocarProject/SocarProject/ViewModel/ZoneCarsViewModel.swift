//
//  ZoneCarsViewModel.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/12.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class ZoneCarsViewModel {
    let sections : [(header: String, category: String)] = [("전기", "EV"),
                                                        ("소형", "COMPACT"),
                                                        ("소형_SUV", "COMPACT_SUV"),
                                                        ("준중형 SUV", "SEMI_MID_SUV"),
                                                        ("준중형 세단", "SEMI_MID_SEDAN"),
                                                        ("중형 SUV", "MID_SUV"),
                                                        ("중형 SEDAN", "MID_SEDAN")]
    
    // MARK: Properties
    private let zonesService : ZoneCarsServiceProtocol
    var category : [SocarZoneDataSection] = []
    let sectionSubject = BehaviorRelay(value: [SocarZoneDataSection]())

    // MARK:
    init(zonesService: ZoneCarsServiceProtocol) {
        self.zonesService = zonesService
    }

    func fetchsCars(_ id: String) {
        ZoneCarsService().requestCars(id) { [weak self] error ,carInfo in
            guard let self = self else { return }
            guard let carInfo = carInfo  else { return }
            
            for section in self.sections {
                let items = carInfo.map{ ZoneCarsEntity(cars: $0)}.filter{ $0.category == section.category }
                if !items.isEmpty {
                    let dataSection = SocarZoneDataSection(header: section.header, items: items)
                    self.category.append(dataSection)
                }
            }
            
            self.sectionSubject.accept(self.category)
        }
    }
    
    // 즐겨찾기 존 데이터 저장 그리고 삭제
    func saveData(_ zoneName: String, _ zoneId: String, _ zoneAlies: String) {
        let realm = try! Realm()
        try! realm.write({
            let data = FavoriteZoneEntity()
            data.zoneName = zoneName
            data.zoneId = zoneId
            data.zoneAlies = zoneAlies
            realm.add(data)
        })
    }
    
    func deleteData(_ zoneID: String) {
        let realm = try! Realm()
        if let delete = realm.objects(FavoriteZoneEntity.self).filter( "zoneId == '\(zoneID)'" ).first {
            try! realm.write({
                realm.delete(delete)
            })
        }
    }
}
