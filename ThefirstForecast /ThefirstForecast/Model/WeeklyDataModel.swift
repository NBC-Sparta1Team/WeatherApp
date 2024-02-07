//
//  WeeklyAverageDataModel.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/6/24.
//

import Foundation
struct OneDayAverageData{
    let date : String
    let temp : Double
    let tempMax : Double
    let tempMin : Double
    let feelsLike : Double // 체감온도
    let humidty : Int // 습도
    let windSpeed : Double
    let windDeg : Double
    let rainfall : Double
    let description : String
    let icon : String
}
