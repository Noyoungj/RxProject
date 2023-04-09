//
//  FavoriteViewController.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/12.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteViewController: BaseViewController {
    //MARK: Properties
    lazy var buttonNaviRight: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic24_close")
        button.rx.tap.bind {
            self.coordinator?.dismissMainCoordinator()
        }.disposed(by: disposeBag)
        button.tag = 1
        button.tintColor = .Color28323C
        return button
    }()
    
    let labelSocarFavorite : UILabel = {
        let label = UILabel()
        label.text = "쏘카존 즐겨찾기"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .Color28323C
        return label
    }()
    
    let tableViewContent : UITableView =  {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        return tableView
    }()
    
    let favoriteZone : [FavoriteZoneEntity]
    weak var coordinator: MainCoordinator?
    let delegate : disMissAndPushVCProtocol
    
    let disposeBag = DisposeBag()

    //MARK: Lifecycle
    init(_ favoriteData: [FavoriteZoneEntity], _ previousViewController: MapViewController) {
        self.favoriteZone = favoriteData
        self.delegate = previousViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: Config
    private func configureUI() {
        setNavigationBar()
        setSocarLabel()
        setTableView()
    }
    
    private func setNavigationBar() {
        let height: CGFloat = 75
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = UIColor.clear
        navbar.delegate = self

        let navItem = UINavigationItem()
        navItem.rightBarButtonItem = self.buttonNaviRight
        navbar.items = [navItem]
        navbar.setBackgroundImage(UIImage(), for: .default)
        navbar.shadowImage = UIImage()
        navbar.layoutIfNeeded()
        view.addSubview(navbar)
    }
    
    private func setSocarLabel() {
        view.addSubview(labelSocarFavorite)
        labelSocarFavorite.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(24)
            make.top.equalTo(view).offset(112)
        }
    }
    
    private func setTableView() {
        tableViewContent.delegate = self
        tableViewContent.dataSource = self
        tableViewContent.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseIdentifier)
        view.addSubview(tableViewContent)
        tableViewContent.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(labelSocarFavorite.snp.bottom).offset(24)
            make.bottom.equalTo(view).offset(-64)
        }
    }
}

extension FavoriteViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteZone.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseIdentifier, for: indexPath) as? FavoriteTableViewCell else {return UITableViewCell()}
        
        cell.labelZoneName.text = self.favoriteZone[indexPath.row].zoneName
        cell.labelZoneInfo.text = self.favoriteZone[indexPath.row].zoneAlies
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let zoneId = self.favoriteZone[indexPath.row].zoneId
        self.delegate.upDateZonedId(zoneId)
        self.coordinator?.dismissMainCoordinator()
    }
}

extension FavoriteViewController : UINavigationBarDelegate {
    
}
