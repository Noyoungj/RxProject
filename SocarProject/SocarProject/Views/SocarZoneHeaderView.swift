//
//  SocarZoneHeaderView.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/13.
//

import UIKit

final class SocarZoneHeaderView : UITableViewHeaderFooterView {

    //MARK: Properties
    static let reuseIdentifier = "SocarZoneHeaderView"
    
    let label : UILabel = {
        let label = UILabel()
        label.font = UIFont.fontWithName(type: .semibold, size: 16)
        label.textColor = .Color374553
        return label
    }()
    
    //MARK: LifeCycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        ConfigureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    private func ConfigureUI() {
        self.backgroundColor = .white
        
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(24)
            make.trailing.equalTo(self).offset(-24)
            make.bottom.equalTo(self)
        }
    }
}
