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
    let windSpeed : Double // 풍향
    let windDeg : Double // 풍각
    let rainfall : Double // 강수량
    let description : String // 
    let icon : String
}
struct OneDay3HourDataModel {
    let hour : String
    let icon: String
    let temp : Double
}
