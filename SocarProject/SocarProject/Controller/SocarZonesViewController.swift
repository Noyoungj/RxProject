//
//  SocarZonesViewController.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/12.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

final class SocarZonesViewController: BaseViewController, UIScrollViewDelegate {
    //MARK: Properties
    let viewTopContent : UIView =  {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let labelZoneName : UILabel = {
        let label = UILabel()
        label.font = UIFont.fontWithName(type: .semibold, size: 18)
        label.textColor = .Color28323C
        return label
    }()
    let labelZoneAlies : UILabel = {
        let label = UILabel()
        label.font = UIFont.fontWithName(type: .semibold, size: 14)
        label.textColor = .Color374553
        return label
    }()
    let buttonFavorite : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "_ic24_favorite_gray"), for: .normal)
        button.setImage(UIImage(named: "_ic24_favorite_blue"), for: .selected)
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    let tableViewContent : UITableView =  {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    let viewModel : ZoneCarsViewModel
    var coordinator : MainCoordinator?
    let zoneId : String
    let zoneName : String
    let zoneAlies : String
    let buttonBool : Bool
    
    let dataSource = RxTableViewSectionedReloadDataSource<SocarZoneDataSection> { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarInfoTableViewCell.reuseIdentifier, for: indexPath) as? CarInfoTableViewCell else { return UITableViewCell() }
        
        cell.bind(item)
        
        return cell
    }
    
    //MARK: LifeCycle
    init(_ viewModel : ZoneCarsViewModel, _ zoneId: String, _ zoneName: String, _ zoneAlies: String, _ boolButton: Bool) {
        self.viewModel = viewModel
        self.zoneId = zoneId
        self.zoneName = zoneName
        self.zoneAlies = zoneAlies
        self.viewModel.fetchsCars(self.zoneId)
        self.buttonBool = boolButton
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        viewModel.sectionSubject.bind(to: tableViewContent.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    //MARK: Config
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        setTopView()
        setTableView()
    }
    
    private func setTopView() {
        view.addSubview(viewTopContent)
        viewTopContent.snp.makeConstraints { make in
            make.top.equalTo(view).offset(88)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(70)
        }
        
        labelZoneName.text = self.zoneName
        viewTopContent.addSubview(labelZoneName)
        labelZoneName.snp.makeConstraints { make in
            make.leading.equalTo(viewTopContent).offset(24)
            make.top.equalTo(viewTopContent).offset(16)
        }
        
        labelZoneAlies.text = self.zoneAlies
        viewTopContent.addSubview(labelZoneAlies)
        labelZoneAlies.snp.makeConstraints { make in
            make.leading.equalTo(labelZoneName)
            make.top.equalTo(labelZoneName.snp.bottom).offset(4)
        }
        
        buttonFavorite.rx.tap.bind {
            switch self.buttonFavorite.isSelected {
            case true:
                self.buttonFavorite.isSelected = false
                
                self.viewModel.deleteData(self.zoneId)
            case false:
                self.buttonFavorite.isSelected = true
                
                self.viewModel.saveData(self.zoneName, self.zoneId, self.zoneAlies)
            }
        }.disposed(by: disposeBag)
        buttonFavorite.isSelected = buttonBool
        viewTopContent.addSubview(buttonFavorite)
        buttonFavorite.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalTo(viewTopContent)
            make.trailing.equalTo(viewTopContent).offset(-24)
        }
    }
    
    private func setTableView() {
        tableViewContent.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableViewContent.register(CarInfoTableViewCell.self, forCellReuseIdentifier: CarInfoTableViewCell.reuseIdentifier)
        tableViewContent.register(SocarZoneHeaderView.self, forHeaderFooterViewReuseIdentifier: SocarZoneHeaderView.reuseIdentifier)
        view.addSubview(tableViewContent)
        tableViewContent.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(viewTopContent.snp.bottom)
            make.bottom.equalTo(view).offset(-64)
        }
    }
    // MARK: Helpers
    
}

extension SocarZonesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SocarZoneHeaderView.reuseIdentifier) as? SocarZoneHeaderView else { return UIView() }
        if !viewModel.category.isEmpty {
            view.label.text = viewModel.category[section].header
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
}
