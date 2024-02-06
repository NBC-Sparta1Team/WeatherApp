//
//  APIService.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import Foundation
class WeatherMapAPIManger{
    static let shared = WeatherMapAPIManger()
    let APIKey = Bundle.init().infoDictionary?["OpenWeatherMap_KEY"] as! String
 
}
