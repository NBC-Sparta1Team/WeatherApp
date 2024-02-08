//
//  5DaysForecastVC.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit

class WeeklyForecastVC: UIViewController {
    var weeklyTableView: UITableView!

    
    var weatherForecasts: [WeatherForecast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getWeeklyAverageData(coordiante: Coordinate(lat: 35.8312, lon: 128.7385))
        self.view.backgroundColor = .white
        
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
            weeklyTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weeklyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weeklyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weeklyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        
        weatherForecasts = dummyWeatherForecasts
        
        weeklyTableView.reloadData()
      
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

