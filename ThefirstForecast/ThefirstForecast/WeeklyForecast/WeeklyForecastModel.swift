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
    WeatherForecast(date: "01-26", dayOfWeek: "Monday", minTemperature: 10.0, maxTemperature: 20.0, averageTemperature: 15.0, precipitation: 5.0, weatherIcon: UIImage(named: "HomeImg")!),
    WeatherForecast(date: "01-27", dayOfWeek: "Tuesday", minTemperature: 8.0, maxTemperature: 18.0, averageTemperature: 13.0, precipitation: 2.0, weatherIcon: UIImage(named: "HomeImg")!),
    WeatherForecast(date: "01-28", dayOfWeek: "Wednesday", minTemperature: 12.0, maxTemperature: 22.0, averageTemperature: 17.0, precipitation: 8.0, weatherIcon: UIImage(named: "HomeImg")!),
    WeatherForecast(date: "01-29", dayOfWeek: "Thursday", minTemperature: 6.0, maxTemperature: 16.0, averageTemperature: 11.0, precipitation: 3.0, weatherIcon: UIImage(named: "HomeImg")!),
    WeatherForecast(date: "01-30", dayOfWeek: "Friday", minTemperature: 11.0, maxTemperature: 21.0, averageTemperature: 16.0, precipitation: 4.0, weatherIcon: UIImage(named: "HomeImg")!)
]
