//
//  MainVC.swift
//  ThefirstForecast
//  Created by 원동진 on 2/5/24.
//

import Foundation
import UIKit

struct MainWeather {
    var location: String
    var windSpeed: String
    var minTemperature: Int
    var maxTemperature: Int
    var averageTemperature: Int
    var backgroundImage: UIImage?
}

class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    

    var collectionView: UICollectionView!
    var searchController: UISearchController!
    var searchResultsController: searchControllerVC!
    let weatherLabel = UILabel()
    let settingButton = UIButton(type: .system)
    
    var dummyData: [MainWeather] = [
        MainWeather(location: "서울", windSpeed: "풍속: 5m/s", minTemperature: -5, maxTemperature: 3, averageTemperature: -1),
        MainWeather(location: "부산", windSpeed: "풍속: 3m/s", minTemperature: 0, maxTemperature: 8, averageTemperature: 4),
        MainWeather(location: "부산", windSpeed: "풍속: 3m/s", minTemperature: 0, maxTemperature: 8, averageTemperature: 4)
    ]
    
    var filteredData: [Weather] = [] // 필터링된 결과 저장 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getSearchData(input: "38613")
//        getForecastData(from: Coordinate(lat: 35.8312, lon: 128.7385))
        self.view.backgroundColor = .white
        
        // 콜렉션 뷰 레이아웃 설정
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // 각 셀 크기 설정
        let cellWidth = (view.frame.width - 1.5 * 20)
        layout.itemSize = CGSize(width: cellWidth, height: 80)
        
        // 검색 결과 표시용 VC 초기화
        searchResultsController = searchControllerVC()
        
        //콜렉션 뷰 초기화 및 설정
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(collectionView)
        
        //검색 컨트롤러 설정
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "도시 또는 공항 검색"
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
 
    // 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .lightGray
        
        // 지역 이름 레이블 추가
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 150, height: 20))
        locationLabel.text = dummyData[indexPath.row].location
        locationLabel.font = UIFont.boldSystemFont(ofSize: 16)
        cell.contentView.addSubview(locationLabel)
        
        // 풍속 레이블 추가
        let windSpeedLabel = UILabel(frame: CGRect(x: 10, y: 40, width: 150, height: 20))
        windSpeedLabel.text = dummyData[indexPath.row].windSpeed
        windSpeedLabel.font = UIFont.systemFont(ofSize: 14)
        cell.contentView.addSubview(windSpeedLabel)
        
        // 최저/최고 온도 레이블 추가
        let temperatureLabel = UILabel(frame: CGRect(x: cell.contentView.bounds.width - 160, y: 10, width: 150, height: 20))
        temperatureLabel.text = "최저: \(dummyData[indexPath.row].minTemperature)℃  최고: \(dummyData[indexPath.row].maxTemperature)℃"
        temperatureLabel.textAlignment = .right
        temperatureLabel.font = UIFont.systemFont(ofSize: 14)
        cell.contentView.addSubview(temperatureLabel)
        
        // 평균 온도 레이블 추가
        let averageTemperatureLabel = UILabel(frame: CGRect(x: cell.contentView.bounds.width - 160, y: 40, width: 150, height: 20))
        averageTemperatureLabel.text = "\(dummyData[indexPath.row].averageTemperature)℃"
        averageTemperatureLabel.textAlignment = .right
        averageTemperatureLabel.font = UIFont.systemFont(ofSize: 14)
        cell.contentView.addSubview(averageTemperatureLabel)
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
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
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .white
            self.navigationController?.navigationBar.topItem?.titleView = searchController.searchBar
            self.navigationItem.titleView?.backgroundColor = .white
            self.navigationItem.titleView?.frame = searchController.searchBar.frame
            searchController.searchBar.showsCancelButton = true
            UIView.animate(withDuration: 0.5, animations: {
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
        UIView.animate(withDuration: 0.1, animations: {
            self.weatherLabel.alpha = 1
            self.settingButton.alpha = 1
        }) { _ in
            self.weatherLabel.isHidden = false
            self.settingButton.isHidden = false
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // 검색 결과 업데이트 코드
        _ = searchController.searchBar.text ?? ""
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MainVC{
    func getSearchData(input : String){ // Search했을 경우 사용 되는 날씨 정보 API
        ForecastAPIManger.shared.SynthesizeGetCoodinateData(from: input) { ForecastInfoModel in
            let foreCastDataFromSearch = ForecastInfoModel
        }
    }
    func getForecastData(from coordinate : Coordinate){ //  좌표로 날씨 정보를 불러오는 API
        ForecastAPIManger.shared.getForecastData(from: coordinate) { ForecastInfoModel in
            let foreCastDataFromCoordinate = ForecastInfoModel
        }
    }
}
