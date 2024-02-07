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

        self.view.backgroundColor = .white
        
        weeklyTableView = UITableView(frame: view.bounds, style: .plain)
        
        weeklyTableView.backgroundColor = .white
        weeklyTableView.dataSource = self
        weeklyTableView.delegate = self
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyForecastTableViewCell", for: indexPath) as! WeeklyForecastTableViewCell
        
        let forecast = weatherForecasts[indexPath.row]
        cell.dateLabel.text = forecast.date
            cell.dayOfWeekLabel.text = forecast.dayOfWeek
            cell.minTemperatureLabel.text = "\(forecast.minTemperature) °C"
            cell.maxTemperatureLabel.text = "\(forecast.maxTemperature) °C"
            cell.averageTemperatureLabel.text = "\(forecast.averageTemperature) °C"
            cell.precipitationLabel.text = "\(forecast.precipitation) mm"
            cell.weatherIconImageView.image = forecast.weatherIcon
            
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0 // 固定高度為 50 點
    }
    
}

extension WeeklyForecastVC: UITableViewDelegate {
}

