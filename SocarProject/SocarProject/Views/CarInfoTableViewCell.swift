//
//  CarInfoTableViewCell.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/13.
//

import UIKit

final class CarInfoTableViewCell: UITableViewCell {
    //MARK: Properties
    let viewContent : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let imageViewCar : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let labelCarName : UILabel = {
        let label = UILabel()
        label.font = UIFont.fontWithName(type: .regular, size: 16)
        label.textColor = .Color374553
        return label
    }()
    let labelCarInfo : UILabel = {
        let label = UILabel()
        label.font = UIFont.fontWithName(type: .regular, size: 14)
        label.textColor = .Color898989
        return label
    }()
    let viewGap : UIView = {
        let view = UIView()
        view.backgroundColor = .ColorEDEDED
        return view
    }()
    
    static let reuseIdentifier = "CarInfoTableViewCell"
    
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
        
        viewContent.addSubview(imageViewCar)
        imageViewCar.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.leading.equalTo(viewContent).offset(24)
            make.centerY.equalTo(viewContent)
        }
        
        viewContent.addSubview(labelCarName)
        labelCarName.snp.makeConstraints { make in
            make.leading.equalTo(imageViewCar.snp.trailing).offset(16)
            make.centerY.equalTo(imageViewCar).offset(-12)
            make.trailing.equalTo(viewContent).offset(-24)
        }
        
        viewContent.addSubview(labelCarInfo)
        labelCarInfo.snp.makeConstraints { make in
            make.leading.equalTo(imageViewCar.snp.trailing).offset(16)
            make.centerY.equalTo(imageViewCar).offset(12)
            make.trailing.equalTo(viewContent).offset(-24)
        }
        
        viewContent.addSubview(viewGap)
        viewGap.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(viewContent)
            make.leading.equalTo(imageViewCar)
            make.trailing.equalTo(labelCarInfo)
        }
    }
    
    //Helpers
    func bind(_ entity: ZoneCarsEntity) {
        guard let urlString = entity.imageUrl else { return }
        let url = URL(string: urlString)
        self.imageViewCar.kf.setImage(with: url)
        self.imageViewCar.kf.indicatorType = .activity
        
        self.labelCarName.text = entity.name
        self.labelCarInfo.text = entity.description
    }
}
