//
//  MainVC.swift
//  ThefirstForecast
//  Created by 원동진 on 2/5/24.
//
// 
import Foundation
import UIKit
import CoreLocation

class MainVC: UIViewController {
    
    var locationManager =  CLLocationManager()
    var currentCoordinate  = Coordinate(lat: 0.0, lon: 0.0)
    var coordinateArr : [Coordinate] = []
    var forecastInfoArr : [ForecastInfoModel] = []
    var currentForecastInfo : ForecastInfoModel?
    
    private var searchController : UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()
    // 콜렉션 뷰 레이아웃 설정
    private let layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        // 각 셀 크기 설정
        return layout
    }()
    
    private lazy var mainCollectionView : UICollectionView = {
        //콜렉션 뷰 초기화 및 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identi)
        collectionView.register(MainCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainCollectionViewHeader.identi)
        return collectionView
    }()
    private lazy var searchCotainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLoaction()
        getCoreData()
        CoreDataManager.shared.deleteAllData()
        self.view.addSubview(mainCollectionView)
        self.view.backgroundColor = .white
        setNavigationBarButtonItem()
        setSearchController()
        setAutoLayout()
    }
    private func setAutoLayout(){
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant : -10),
            mainCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -10)
        ])
    }
    private func setNavigationBarButtonItem(){
        let weatherBarbuttonItem = UIBarButtonItem(title: "날씨", style: .plain, target:self, action: nil) //날씨버튼
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingButtonTapped)) //설정버튼
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30.0),NSAttributedString.Key.foregroundColor : UIColor.black] // 날씨 글자 Font크키와 색상변경을 위함
        weatherBarbuttonItem.setTitleTextAttributes(attributes, for: .normal)
        settingButton.tintColor = .black // Button Color
        
        navigationItem.leftBarButtonItem = weatherBarbuttonItem
        navigationItem.rightBarButtonItem = settingButton
    }
    private func setSearchController(){
        //검색 컨트롤러 설정
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "도시 또는 우편번호 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    private func getCoreData(){
        let coreDataList = CoreDataManager.shared.readMapData()
        for data in coreDataList{
            ForecastAPIManger.shared.getForecastData(from: Coordinate(lat: data.lat, lon: data.lon)) { forecastInfoModel in
                DispatchQueue.main.sync {
                    self.forecastInfoArr.append(forecastInfoModel)
                    self.mainCollectionView.reloadData()
                }
            }
        }
    }
}
//MARK: - SearchController
extension MainVC : UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) { // searchResultsController 사용 안함으로 인해 공백
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else { return }
        let vc = ForecastInfoVC()
        vc.addActionDelegate = self
        ForecastAPIManger.shared.SynthesizeGetCoodinateData(from: text) { forecastInfoModel,status  in
            if status{
                DispatchQueue.main.async {
                    vc.forecastInfo = forecastInfoModel
                    vc.fourForecastData.append(FourForecastStatusModel(title: "체감온도", value: Int(forecastInfoModel?.main.feelsLike ?? 0), icon: "thermometer.medium"))
                    vc.fourForecastData.append(FourForecastStatusModel(title: "강수량", value: Int(forecastInfoModel?.rain?.rain1H ?? 0), icon: "drop.fill"))
                    vc.fourForecastData.append(FourForecastStatusModel(title: "가시거리", value: forecastInfoModel?.visibility ?? 0, icon: "eye.fill"))
                    vc.fourForecastData.append(FourForecastStatusModel(title: "습도", value: forecastInfoModel?.main.humidity ?? 0, icon: "humidity"))
                    vc.windy = forecastInfoModel?.wind
                    vc.modalPresentationStyle = .fullScreen
                    vc.plustButtonShow()
                    self.present(vc, animated: true)
                }
                
                
            }else{
                DispatchQueue.main.async{
                    let vc = searchControllerVC()
                    vc.updateUI(with: text)
                    
                    self.present(vc, animated: true)
                }
            }
            
        }
    }
}
//MARK: - Button Action
extension MainVC {
    @objc func settingButtonTapped() {
        let alertController = UIAlertController(title: "온도 단위 선택", message: "원하는 단위를 선택하세요.", preferredStyle: .actionSheet)
        
        let celsiusAction = UIAlertAction(title: "섭씨", style: .default) { action in
            TempStateData.shared.state = true
            self.mainCollectionView.reloadData()
            print("섭씨 선택")
        }
        
        let fahrenheitAction = UIAlertAction(title: "화씨", style: .default) { action in
            TempStateData.shared.state = false
            self.mainCollectionView.reloadData()
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
   
}
extension MainVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    //MARK: - CollectionView CEll
    func numberOfSections(in collectionView: UICollectionView) -> Int { //섹션 개수
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{ // 0 번째 섹션 의 Ceel의 개수는 1개
            return 1
        } else{ // 검색해서 추가한 날씨 정보 개수
            return forecastInfoArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identi, for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
            if let currentForecastData = self.currentForecastInfo{
                cell.setCell(model: currentForecastData)
            }
            return cell
            
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identi, for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
            cell.setCell(model: forecastInfoArr[indexPath.item])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 100) // Cell Size
    }
    //MARK: - CollectionView Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainCollectionViewHeader.identi, for: indexPath) as? MainCollectionViewHeader else { return MainCollectionViewHeader()}
            if indexPath.section == 0{
                header.setLabel(text: "현재 위치")
            }else{
                header.setLabel(text: "추가한 위치")
            }
            return header
            
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize { //Header Size
        return CGSize(width: collectionView.frame.width - 20, height: 20)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{ // 현재 위치 날씨 정보 데이터
            let vc = ForecastInfoVC()
            vc.forecastInfo = self.currentForecastInfo
            
            vc.fourForecastData.append(FourForecastStatusModel(title: "체감온도", value: Int(self.currentForecastInfo?.main.feelsLike ?? 0), icon: "thermometer.medium"))
            vc.fourForecastData.append(FourForecastStatusModel(title: "강수량", value: Int(self.currentForecastInfo?.rain?.rain1H ?? 0), icon: "drop.fill"))
            vc.fourForecastData.append(FourForecastStatusModel(title: "가시거리", value: self.currentForecastInfo?.visibility ?? 0, icon: "eye.fill"))
            vc.fourForecastData.append(FourForecastStatusModel(title: "습도", value: self.currentForecastInfo?.main.humidity ?? 0, icon: "humidity"))
            vc.modalPresentationStyle = .fullScreen
            vc.addActionDelegate = self
            self.present(vc, animated: true)
        }else{ // 검색해서 추가한 날씨 정보 데이터
            let vc = ForecastInfoVC()
            let foreCastInfoData = forecastInfoArr[indexPath.item]
            vc.forecastInfo = foreCastInfoData
            vc.fourForecastData.append(FourForecastStatusModel(title: "체감온도", value: Int(foreCastInfoData.main.feelsLike), icon: "thermometer.medium"))
            vc.fourForecastData.append(FourForecastStatusModel(title: "강수량", value: Int(foreCastInfoData.rain?.rain1H ?? 0), icon: "drop.fill"))
            vc.fourForecastData.append(FourForecastStatusModel(title: "가시거리", value: foreCastInfoData.visibility, icon: "eye.fill"))
            vc.fourForecastData.append(FourForecastStatusModel(title: "습도", value: foreCastInfoData.main.humidity, icon: "humidity"))
            vc.windy = foreCastInfoData.wind
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}
//MARK: - 현재위치 & 현재위치 날씨 정보 데이터
extension MainVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // 현재 사용자 위치 받아오기
        let location = locations[locations.count - 1]
        CurrentCoordinateModel.shared.currentCoordinate = Coordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        ForecastAPIManger.shared.getForecastData(from: CurrentCoordinateModel.shared.currentCoordinate) { forecastInfoModel in
            DispatchQueue.main.async {
                self.currentForecastInfo = forecastInfoModel
                self.mainCollectionView.reloadData()
            }
            
        }
    }
    func getCurrentLoaction(){ // 현재 위치 정보 Get
        locationManager = CLLocationManager()// CLLocationManager클래스의 인스턴스 locationManager를 생성
        locationManager.delegate = self// 포그라운드일 때 위치 추적 권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest// 배터리에 맞게 권장되는 최적의 정확도
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()// 위치 업데이트
    }
}
extension MainVC :  AddActionSendDelegate {
    func sendForecastInfo(data: ForecastInfoModel) {
        self.forecastInfoArr.append(data)
        self.mainCollectionView.reloadData()
    }
    
}
