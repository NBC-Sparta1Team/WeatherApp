//
//  5DaysForecastVC.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit

class WeeklyForecastVC: UIViewController {
    var weeklyTableView: UITableView!
    var weeklyWeatherLabel: UILabel!
    let weeklySettingButton = UIButton(type: .system)
    
    var weatherForecasts: [WeatherForecast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getWeeklyAverageData(coordiante: Coordinate(lat: 35.8312, lon: 128.7385))
        self.view.backgroundColor = .white
        
        // 在 view 上方添加 titleLabel
        weeklyWeatherLabel = UILabel()
        weeklyWeatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weeklyWeatherLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        weeklyWeatherLabel.text = "현재 위치 예보"
              
                view.addSubview(weeklyWeatherLabel)
        
        // 섭화씨 전환 버튼 추가
        weeklySettingButton.isEnabled = true
        weeklySettingButton.setImage(UIImage(systemName: "gear"), for: .normal)
        weeklySettingButton.tintColor = .black
        weeklySettingButton.translatesAutoresizingMaskIntoConstraints = false
        weeklySettingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        weeklySettingButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                self.view.addSubview(weeklySettingButton)
        
        
        weeklyTableView = UITableView(frame: view.bounds, style: .plain)
        
        weeklyTableView.backgroundColor = .white
        weeklyTableView.dataSource = self
        weeklyTableView.delegate = self
        weeklyTableView.separatorStyle = .none
        weeklyTableView.showsVerticalScrollIndicator = false
        weeklyTableView.register(WeeklyForecastTableViewCell.self, forCellReuseIdentifier: "WeeklyForecastTableViewCell")
        view.addSubview(weeklyTableView)
        
        weeklyTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        weeklyWeatherLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: -60),
        weeklyWeatherLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        
        weeklySettingButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -60),
        weeklySettingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
                        
            
        weeklyTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 170),
        weeklyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        weeklyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        weeklyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        
        weatherForecasts = dummyWeatherForecasts
        
        weeklyTableView.reloadData()
       
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
            present(alertController, animated: true, completion: nil)
        }
}


extension WeeklyForecastVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyForecastTableViewCell", for: indexPath)
        as! WeeklyForecastTableViewCell
        
        let forecast = weatherForecasts[indexPath.row]
        cell.dateLabel.text = forecast.date
            cell.minTemperatureLabel.text = "\(forecast.minTemperature) °"
            cell.maxTemperatureLabel.text = "\(forecast.maxTemperature) °"
            cell.averageTemperatureLabel.text = "\(forecast.averageTemperature) °"
            cell.precipitationLabel.text = "\(forecast.precipitation) 1m/s"
            cell.weatherIconImageView.image = forecast.weatherIcon
        
        
        return cell
    }
}

extension WeeklyForecastVC: UITableViewDelegate {
 //畫幾次
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
}



extension WeeklyForecastVC {
    func getWeeklyAverageData(coordiante : Coordinate){
        WeeklyForecastAPIManger.shred.getWeeklyAverageData(from: coordiante) { oneDayAverageData in
            let oneDayAverageDataList = oneDayAverageData
        }
    }
}

