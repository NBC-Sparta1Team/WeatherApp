//
//  CityCoordianteModel.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/6/24.
//

import Foundation

struct CoordinateModel : Decodable{
    let name : String
    let lat, lon : Double
}
struct Coordinate{
    let lat : Double?
    let lon : Double?
}
struct FourForecastStatusModel{
    let title : String
    let value : Int
    let icon : String
}
// MARK: - ForecastInfoModel
struct ForecastInfoModel: Decodable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let visibility : Int
    let wind: Wind
    let rain: Rain?
//    let snow : Snow?
//    let clouds: Clouds
    let name : String
}
// MARK: - WeeklyForecastModel
struct WeeklyForecastModel: Decodable {
    let list: [List]
    let city: City
}
// MARK: - Coord
struct Coord: Decodable {
    let lat : Double
    let lon : Double
}
// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main : String // 날씨 매개 변수 그룹
    let description : String // 그룹내 날씨 상태
    let icon : String// 날씨 아이콘
}
// MARK: - Main
struct Main: Decodable {
    let temp : Double // 온도
    let feelsLike : Double // 체감온도
    let tempMin : Double // 최저기온
    let tempMax : Double // 최고 기온
    let humidity: Int // 습도
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}
// MARK: - Wind
struct Wind: Decodable {
    let speed: Double // 바람속도
    let deg: Int // 풍향,각도
    let gust : Double?
}
// MARK: - Rain
struct Rain: Decodable {
    let rain3H: Double?
    let rain1H: Double?
    enum CodingKeys: String, CodingKey {
        case rain1H = "1h"
        case rain3H = "3h"
        
    }
}
//MARK: - Snow
struct Snow : Decodable {
    let snow3H: Double?
    let snow1H: Double?
    enum CodingKeys: String, CodingKey {
        case snow1H = "1h"
        case snow3H = "3h"
    }
}
// MARK: - Clouds
struct Clouds: Decodable {
    let all: Int // 흐림,%
}
// MARK: - City
struct City: Decodable {
    let id: Int
    let name: String
    let coord : Coord
}
// MARK: - List
struct List: Decodable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let rain: Rain?
    let snow : Snow?
    let clouds: Clouds
    let dtTxt: String
    let visibility : Int
    enum CodingKeys: String, CodingKey {
        case weather,main,wind,rain,snow,clouds,visibility
        case dtTxt = "dt_txt"
    }
}

