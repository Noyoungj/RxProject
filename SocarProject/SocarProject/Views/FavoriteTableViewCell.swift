//
//  FavoriteTableViewCell.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/14.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {
    //MARK: Properties
    let viewContent : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let imageViewZone : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_zone")
        return imageView
    }()
    let labelZoneName : UILabel = {
        let label = UILabel()
        label.font = UIFont.fontWithName(type: .semibold, size: 16)
        label.text = "아크로포레스트"
        label.textColor = .Color374553
        return label
    }()
    let labelZoneInfo : UILabel = {
        let label = UILabel()
        label.font = UIFont.fontWithName(type: .regular, size: 14)
        label.text = "서울숲역"
        label.textColor = .Color374553
        return label
    }()
    let viewGap : UIView = {
        let view = UIView()
        view.backgroundColor = .ColorEDEDED
        return view
    }()
    
    static let reuseIdentifier = "FavoriteTableViewCell"
    
    //MARK: LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    private func configureUI() {
        self.selectionStyle = .none
        
        self.addSubview(viewContent)
        viewContent.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        viewContent.addSubview(imageViewZone)
        imageViewZone.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(47)
            make.leading.equalTo(viewContent).offset(24)
            make.centerY.equalTo(viewContent)
        }
        
        viewContent.addSubview(labelZoneName)
        labelZoneName.snp.makeConstraints { make in
            make.leading.equalTo(imageViewZone.snp.trailing).offset(16)
            make.centerY.equalTo(imageViewZone).offset(-12)
            make.trailing.equalTo(viewContent).offset(-24)
        }
        
        viewContent.addSubview(labelZoneInfo)
        labelZoneInfo.snp.makeConstraints { make in
            make.leading.equalTo(imageViewZone.snp.trailing).offset(16)
            make.centerY.equalTo(imageViewZone).offset(12)
            make.trailing.equalTo(viewContent).offset(-24)
        }
        
        viewContent.addSubview(viewGap)
        viewGap.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(viewContent)
            make.leading.equalTo(imageViewZone)
            make.trailing.equalTo(labelZoneInfo)
        }
    }
}
