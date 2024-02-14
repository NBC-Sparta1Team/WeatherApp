//
//  MainVC.swift
//  ThefirstForecast
//  Created by 원동진 on 2/5/24.
//

import Foundation
import UIKit
import CoreLocation
struct MainWeather {
    var location: String
    var windSpeed: String
    var minTemperature: Int
    var maxTemperature: Int
    var averageTemperature: Int
    var backgroundImage: UIImage?
}

class MainVC: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    var locationManager =  CLLocationManager()
    var currentCoordinate  = Coordinate(lat: 0.0, lon: 0.0)
    
    var searchController: UISearchController!
    var searchResultsController: searchControllerVC!
    let weatherLabel = UILabel()
    let settingButton = UIButton(type: .system)
    
    var coordinateArr : [Coordinate] = []
    var forecastInfoArr : [ForecastInfoModel] = []
    
    // 콜렉션 뷰 레이아웃 설정
    private let layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // 각 셀 크기 설정
        return layout
    }()
    
    private lazy var collectionView : UICollectionView = {
        //콜렉션 뷰 초기화 및 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identi)
        return collectionView
    }()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLoaction()
        
        self.view.backgroundColor = .white
        
        
        
        // 검색 결과 표시용 VC 초기화
        searchResultsController = searchControllerVC()
        
        
        self.view.addSubview(collectionView)
        
        //검색 컨트롤러 설정
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "도시 또는 우편번호 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        // "날씨" 라벨 추가
        weatherLabel.text = "날씨"
        weatherLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(weatherLabel)
        
        // 섭화씨 전환 버튼 추가
        settingButton.isEnabled = true
        settingButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingButton.tintColor = .black
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        settingButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.view.addSubview(settingButton)
        
        
        // UI위치 설정
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:-110),
            weatherLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            collectionView.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: -140),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            settingButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -110),
            settingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
        ])
    }
    
    
    
    @objc func settingButtonTapped() {
        let alertController = UIAlertController(title: "온도 단위 선택", message: "원하는 단위를 선택하세요.", preferredStyle: .actionSheet)
        
        let celsiusAction = UIAlertAction(title: "섭씨", style: .default) { action in
            // 섭씨 선택 시 처리할 동작 추가
            print("섭씨 선택")
        }
        
        let fahrenheitAction = UIAlertAction(title: "화씨", style: .default) { action in
            // 화씨 선택 시 처리할 동작 추가
            print("화씨 선택")
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(celsiusAction)
        alertController.addAction(fahrenheitAction)
        alertController.addAction(cancelAction)
        
        // iPad에서 동작하기 위해 추가
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UISearchControllerDelegate
    
    //검색창 호출과 동시에 실행되는 메서드
    func willPresentSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.0) {
            self.view.backgroundColor = .white
            self.navigationController?.navigationBar.topItem?.titleView = searchController.searchBar
            self.navigationItem.titleView?.backgroundColor = .white
            self.navigationItem.titleView?.frame = searchController.searchBar.frame
            searchController.searchBar.showsCancelButton = true
            UIView.animate(withDuration: 0.0, animations: {
                self.weatherLabel.alpha = 0
                self.settingButton.alpha = 0
            }) { _ in
                self.weatherLabel.isHidden = true
                self.settingButton.isHidden = true
            }
        }
    }
    
    // 검색창이 호출되고난 직후를 처리하는 메서드
    func didPresentSearchController(_ searchController: UISearchController) {
    }
    
    //검색창이 닫혔을때 실행되는 메서드
    func didDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.0, animations: {
            self.weatherLabel.alpha = 1
            self.settingButton.alpha = 1
        }) { _ in
            self.weatherLabel.isHidden = false
            self.settingButton.isHidden = false
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // 검색 결과 업데이트 코드
        //        print(searchController.searchBar.text ?? "")
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else { return }
        ForecastAPIManger.shared.SynthesizeGetCoodinateData(from: text) { forecastInfoModel,status  in
            if status{
                DispatchQueue.main.async {
                    self.forecastInfoArr.append(forecastInfoModel!)
                    self.collectionView.reloadData()
                }
            }else{
                DispatchQueue.main.async{
                    self.searchResultsController.updateUI(with: text)
                    self.present(self.searchResultsController, animated: true)
                }
            }
            
        }
        
    }
}
extension MainVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastInfoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identi, for: indexPath) as? CollectionViewCell else {return UICollectionViewCell()}
        
        cell.setCell(model: forecastInfoArr[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 100)
    }
}
extension MainVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // 현재 사용자 위치 받아오기
        let location = locations[locations.count - 1]
        CurrentCoordinateModel.shared.currentCoordinate = Coordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        if forecastInfoArr.isEmpty {
            ForecastAPIManger.shared.getForecastData(from: CurrentCoordinateModel.shared.currentCoordinate) { forecastInfoModel in
                DispatchQueue.main.async {
                    self.forecastInfoArr.append(forecastInfoModel)
                    self.collectionView.reloadData()
                }
            }
        }else{
            ForecastAPIManger.shared.getForecastData(from: CurrentCoordinateModel.shared.currentCoordinate) { forecastInfoModel in
                DispatchQueue.main.async {
                    self.forecastInfoArr[0] = forecastInfoModel
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    func getCurrentLoaction(){
        locationManager = CLLocationManager()// CLLocationManager클래스의 인스턴스 locationManager를 생성
        locationManager.delegate = self// 포그라운드일 때 위치 추적 권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest// 배터리에 맞게 권장되는 최적의 정확도
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()// 위치 업데이트
    }
}
