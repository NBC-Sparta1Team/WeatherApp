//
//  5DaysForecastVC.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit

class WeeklyForecastVC: UIViewController {
    var weeklyTableView: UITableView!
    
    
    var weatherForecasts: [OneDayAverageData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        weeklyTableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWeeklyAverageData(coordiante: CurrentCoordinateModel.shared.currentCoordinate)
    }
    
    
    
}

extension WeeklyForecastVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyForecastTableViewCell", for: indexPath)
        as! WeeklyForecastTableViewCell
        cell.dateLabel.text = weatherForecasts[indexPath.row].date
        cell.minTemperatureLabel.text = "최저 : \(String(format: "%.1f", weatherForecasts[indexPath.row].tempMin))"
        cell.maxTemperatureLabel.text = "최고 : \(String(format: "%.1f", weatherForecasts[indexPath.row].tempMax)) °"
        cell.averageTemperatureLabel.text = "\(String(format: "%.1f", weatherForecasts[indexPath.row].temp)) °"
        cell.precipitationLabel.text = "강수량 : \(String(format: "%.3f", weatherForecasts[indexPath.row].rainfall)) m/s"
        if let url = URL(string: "https://openweathermap.org/img/wn/\(weatherForecasts[indexPath.row].icon)@2x.png"){
            cell.weatherIconImageView.load(url: url)
        }
    
        
        
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
            DispatchQueue.main.async {
                self.weatherForecasts = oneDayAverageData
                self.weeklyTableView.reloadData()
            }
        }
    }
}

