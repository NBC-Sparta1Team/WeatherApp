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
}

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView = UITableView()
    
    var dummyData: [MainWeather] = [
        MainWeather(location: "서울", windSpeed: "풍속: 5m/s", minTemperature: -5, maxTemperature: 3, averageTemperature: -1),
        MainWeather(location: "부산", windSpeed: "풍속: 3m/s", minTemperature: 0, maxTemperature: 8, averageTemperature: 4),
        MainWeather(location: "부산", windSpeed: "풍속: 3m/s", minTemperature: 0, maxTemperature: 8, averageTemperature: 4)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        // "날씨" 라벨 추가
        let weatherLabel = UILabel()
        weatherLabel.text = "날씨"
        weatherLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(weatherLabel)
        
        // 검색창 추가
        let searchTextField = UITextField()
        searchTextField.placeholder = "도시 또는 공항 검색"
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "도시 또는 공항 검색", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchTextField)
        
        // 셀 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //테이블 뷰 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
        
        // 섭화씨 전환 버튼 추가
        let settingButton = UIButton(type: .system)
        settingButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingButton.tintColor = .black
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        self.view.addSubview(settingButton)
        
        // UI위치 설정
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -60),
            weatherLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            searchTextField.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            settingButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -60),
            settingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
        ])
    }
    
    // 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // 셀 디자인
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
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
        
        cell.contentView.backgroundColor = .lightGray
        
        return cell
    }
    
    // 셀 세로 크기 및 간격
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 + 20 // 셀 높이 + 간격
    }
    
    @objc func settingButtonTapped() {
        print("섭씨 화씨 전환")
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


