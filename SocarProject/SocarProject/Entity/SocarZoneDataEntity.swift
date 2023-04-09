//
//  File.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/14.
//

import RxDataSources


struct SocarZoneDataSection {
    var header : String
    var items : [ZoneCarsEntity]
}

extension SocarZoneDataSection : SectionModelType {
    typealias Item = ZoneCarsEntity
    
    init(original: SocarZoneDataSection, items: [ZoneCarsEntity]) {
        self = original
        self.items = items
    }
}
