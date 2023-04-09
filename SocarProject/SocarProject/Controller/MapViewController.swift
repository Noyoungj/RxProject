//
//  MapViewController.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/10.
//

import UIKit
import SnapKit
import CoreLocation
import RxSwift
import RxCocoa

protocol disMissAndPushVCProtocol {
    func upDateZonedId(_ zoneId: String)
}

final class MapViewController: BaseViewController {
    //MARK: Properties
    let viewContent : UIView = {
        let view = UIView()
        
        return view
    }()
    let buttonMyLocation : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(named: "ic24_my_location"), for: .normal)
        button.layer.cornerRadius = 22
        
        button.layer.shadowColor = UIColor.Color28323C.cgColor
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        return button
    }()
    let viewFavorite : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 22
        
        view.layer.shadowColor = UIColor.Color28323C.cgColor
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
    let imageViewFavorite : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "_ic24_favorite_black")
        return imageView
    }()
    
    let labelFavorite : UILabel = {
        let label = UILabel()
        label.text = "즐겨찾는 존"
        label.font = UIFont.fontWithName(type: .semibold, size: 14)
        label.textColor = .Color646F7C
        return label
    }()
    
    let buttonFavorite : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    let mapView = MTMapView()
    var locataionManager = CLLocationManager()
    let myLocation = MTMapLocationMarkerItem()
    let socarZoneLocation = MTMapPOIItem()

    // 기본 위치 저장: 서울숲역
    var latitude = 37.54330366639085
    var longitude = 127.04455548501139
    
    let viewModel : MapViewModel
    var coordinator : MainCoordinator?
    var zonesViewModel = BehaviorRelay<[ZonesEntity]>(value: [])
    var zoneId = ""
    var locationAuthorizaion = false
    
    let disposeBag = DisposeBag()
    
    //MARK: LifeCycles
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocation()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.zoneId.isEmpty {
            viewModel.fetchData(self.zonesViewModel.value, self.zoneId) { id, name, alias in
                self.coordinator?.goSocarZoneViewController(id, name, alias)
            }
            self.zoneId = ""
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: Configures
    private func configureUI() {
        configureMap()
        configureMyLocationButton()
        configureFavoriteButton()
    }
    // 카카오 맵 만들기
    private func configureMap() {
        view.addSubview(viewContent)
        viewContent.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        mapView.delegate = self
        
        viewContent.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(viewContent)
        }
                
        // 지도 타입 설정 - satellite: 위성지도
        mapView.baseMapType = .standard
        
        // 현재 위치 트레킹
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        
        // 내위치 이미지 변경
        myLocation.customTrackingImageName = "img_current"
        mapView.updateCurrentLocationMarker(myLocation)
        
        // 지도 센터 설정
        if !locationAuthorizaion {
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: self.latitude, longitude: self.longitude)), animated: false)
        }
    }
    
    
    // 내위치로 되돌리기 버튼
    private func configureMyLocationButton() {
        buttonMyLocation.rx.tap.bind(onNext: { [weak self]_ in
            guard let self = self else { return }
            if !self.locationAuthorizaion {
                self.coordinator?.alert()
            }
        }).disposed(by: disposeBag)
        buttonMyLocation.rx.tap.bind(to: viewModel.currentLocationButtonTapped).disposed(by: disposeBag)
        view.addSubview(buttonMyLocation)
        buttonMyLocation.snp.makeConstraints { make in
            make.trailing.equalTo(view).offset(-16)
            make.bottom.equalTo(view).offset(-56)
            make.height.width.equalTo(44)
        }
    }
    
    // 즐겨찾는 존 버튼
    private func configureFavoriteButton() {
        view.addSubview(viewFavorite)
        viewFavorite.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(16)
            make.top.equalTo(view).offset(60)
            make.width.equalTo(119)
            make.height.equalTo(44)
        }
        
        viewFavorite.addSubview(imageViewFavorite)
        imageViewFavorite.snp.makeConstraints { make in
            make.centerY.equalTo(viewFavorite)
            make.leading.equalTo(viewFavorite).offset(10)
            make.width.height.equalTo(24)
        }
        
        viewFavorite.addSubview(labelFavorite)
        labelFavorite.snp.makeConstraints { make in
            make.centerY.equalTo(viewFavorite)
            make.leading.equalTo(imageViewFavorite.snp.trailing).offset(4)
        }
        
        buttonFavorite.rx.tap.bind {
            self.coordinator?.goFavoriteViewController(self)
        }.disposed(by: disposeBag)
        
        viewFavorite.addSubview(buttonFavorite)
        buttonFavorite.snp.makeConstraints { make in
            make.edges.equalTo(viewFavorite)
        }
    }

    // MARK: Helpers
    private func fetchLocation() {
        locataionManager.delegate = self
        locataionManager.requestWhenInUseAuthorization()
    }
    
    private func bind() {
        viewModel.setMapCenter.emit(to: self.rx.setMapCenterPoint).disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(to: self.rx.initialMapPoint)
            .disposed(by: disposeBag)
        
        self.viewModel.fetchsZones().subscribe(onNext: { [weak self] viewModel in
            guard let self = self else { return }
            self.zonesViewModel.accept(viewModel)
        }).disposed(by: disposeBag)
        
        self.zonesViewModel.map{ $0.map{ $0 } }
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.addPOIItems)
            .disposed(by: disposeBag)
    }
}

extension MapViewController : MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        viewModel.currentLocation.accept((location, true))
    }
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept((mapCenterPoint, true))
    }
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        let zoneId = String(poiItem.tag)
        let zoneInfo = self.zonesViewModel.value.filter{ $0.id == zoneId }
        self.viewModel.mapCenterPoint.accept((MTMapPoint(geoCoord: MTMapPointGeo(latitude: zoneInfo[0].point.0, longitude: zoneInfo[0].point.1)), false))
        self.coordinator?.goSocarZoneViewController(zoneId, zoneInfo[0].name!, zoneInfo[0].alias!)
        return true
    }
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        viewModel.mapViewError.accept((MTMapPoint(geoCoord: MTMapPointGeo(latitude: self.latitude, longitude: self.longitude)), true))
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func getLocationUsagePermisstion() {
        self.locataionManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status  {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationAuthorizaion = true
            return
        case .restricted, .notDetermined:
            getLocationUsagePermisstion()
        case .denied:
            self.locationAuthorizaion = false
            viewModel.mapViewError.accept((MTMapPoint(geoCoord: MTMapPointGeo(latitude: self.latitude, longitude: self.longitude)), true))
        default:
            print("GPS 오류")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error.localizedDescription)")
    }
}

extension MapViewController: disMissAndPushVCProtocol {
    func upDateZonedId(_ zoneId : String) {
        self.zoneId = zoneId
    }
    
}
