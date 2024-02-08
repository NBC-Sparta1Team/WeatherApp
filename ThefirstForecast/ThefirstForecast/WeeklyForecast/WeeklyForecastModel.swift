//
//  WeeklyForecastModel.swift
//  ThefirstForecast
//
//  Created by 洪立妍 on 2/6/24.
//

import Foundation
import UIKit

struct WeatherForecast {
    
    var date: String
    var dayOfWeek: String
    var minTemperature: Double
    var maxTemperature: Double
    var averageTemperature: Double
    var precipitation: Double
    var weatherIcon: UIImage
}
    
let dummyWeatherForecasts: [WeatherForecast] = [
    WeatherForecast(date: "1-26", dayOfWeek: "Monday", minTemperature: 10, maxTemperature: 20, averageTemperature: 15, precipitation: 5, weatherIcon: UIImage(named: "HomeImg")!),
    WeatherForecast(date: "1-27", dayOfWeek: "Tuesday", minTemperature: 8, maxTemperature: 18, averageTemperature: 13, precipitation: 2, weatherIcon: UIImage(named: "HomeImg")!),
    WeatherForecast(date: "1-28", dayOfWeek: "Wednesday", minTemperature: 12, maxTemperature: 22, averageTemperature: 17, precipitation: 8, weatherIcon: UIImage(named: "HomeImg")!),
    WeatherForecast(date: "1-29", dayOfWeek: "Thursday", minTemperature: 6, maxTemperature: 16, averageTemperature: 11, precipitation: 3, weatherIcon: UIImage(named: "HomeImg")!),
    WeatherForecast(date: "1-30", dayOfWeek: "Friday", minTemperature: 11, maxTemperature: 21, averageTemperature: 16, precipitation: 4, weatherIcon: UIImage(named: "HomeImg")!)
]
