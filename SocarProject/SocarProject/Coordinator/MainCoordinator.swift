//
//  Coordinate.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/10.
//

import UIKit
import RealmSwift

protocol Coordinator {
    var navigationController : UINavigationController{ get set }
    func start()
}

final class MainCoordinator : Coordinator {
    var navigationController: UINavigationController
        
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start(){
        let viewController = MapViewController(viewModel: MapViewModel(zonesService: ZonesService()))
        viewController.coordinator = self
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: viewController, action: nil)
        self.navigationController.navigationBar.tintColor = .Color374553
        viewController.navigationItem.backBarButtonItem = backBarButton
        self.navigationController.navigationBar.backIndicatorImage = UIImage(named: "ic24_back")
        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic24_back")
        self.navigationController.viewControllers = [viewController]
    }
    
    func goFavoriteViewController(_ viewController: MapViewController) {
        let realm = try! Realm()
        let favoriteViewController = FavoriteViewController(Array(realm.objects(FavoriteZoneEntity.self)), viewController)
        favoriteViewController.coordinator = self
        favoriteViewController.modalPresentationStyle = .fullScreen
        self.navigationController.present(favoriteViewController, animated: true)
    }
    
    func dismissMainCoordinator() {
        self.navigationController.dismiss(animated: true)
    }

    
    func popMainCoordinator() {
        self.navigationController.popViewController(animated: true)
    }
    
    func goSocarZoneViewController(_ id : String, _ name : String, _ alies: String) {
        let realm = try! Realm()
        let bool = !realm.objects(FavoriteZoneEntity.self).filter(" zoneId == '\(id)'").isEmpty
        let carViewController = SocarZonesViewController(ZoneCarsViewModel(zonesService: ZoneCarsService()), id, name, alies, bool)
        carViewController.coordinator = self
        self.navigationController.pushViewController(carViewController, animated: true)
    }
    
    func alert() {
        let alert = UIAlertController(title: "확인해주세요.", message: "쏘카 서비스 이용을 위해 위치 정보 권한을 허용해주세요.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let OKAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        OKAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        alert.addAction(OKAction)
        
        self.navigationController.present(alert, animated: false)
    }
}
