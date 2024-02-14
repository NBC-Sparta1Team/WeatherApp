//
//  WeeklyDataProcessing.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/6/24.
//

import Foundation
class WeeklyForecastAPIManger{
    static let shred = WeeklyForecastAPIManger()
    let APIKey = Bundle.main.infoDictionary?["OpenWeatherMap_KEY"] as? String
    func getWeeklyForecastData(from coordinate : Coordinate,completion : @escaping(WeeklyForecastModel)->Void){ // 6days/3Hour API
        let url = EndPoint.data(APItype: "forecast").url
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let lat = coordinate.lat else {return}
        guard let lon = coordinate.lon else {return}
        components?.queryItems = [URLQueryItem(name: "lat", value: "\(lat)"),URLQueryItem(name: "lon", value: "\(lon)"),URLQueryItem(name: "appid", value: APIKey),URLQueryItem(name: "lang", value: "kr"),URLQueryItem(name: "units", value: "metric")]
        guard let requestURL = components?.url else { return}
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            guard error == nil else{
                print("Error : \(String(describing: error?.localizedDescription))")
                return
            }
            guard let data = data else {
                return
            }
            do{
                let weeklyForecastData : WeeklyForecastModel = try JSONDecoder().decode(WeeklyForecastModel.self, from: data)
                completion(weeklyForecastData)
            }catch{
                print("Decoding Error : \(String(describing: error.localizedDescription))")
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code getWeeklyForecastData : \(httpResponse.statusCode)")
            }
        }.resume()
    }
    func getWeeklyAverageData(from coordinate : Coordinate ,completion : @escaping([OneDayAverageData],String)->Void){ // 3hour/day 평균 날씨 정보
        var OneDayAverageDataList : [OneDayAverageData] = []
        getOneDaySplitForecastData(coordinate: coordinate) { oneDaySplitForecastDataList,cityName  in
            for oneDayinfoData in oneDaySplitForecastDataList{
                let date = oneDayinfoData[0].dtTxt.split(separator: " ").map{String($0)}.first!
                let oneDaytInfoDatCount = Double(oneDayinfoData.count)
                let temp = oneDayinfoData.map{$0.main.temp}.reduce(0, +) / oneDaytInfoDatCount
                let tempMax = oneDayinfoData.map{$0.main.tempMax}.reduce(0, +) / oneDaytInfoDatCount
                let tempMin = oneDayinfoData.map{$0.main.tempMin}.reduce(0, +) / oneDaytInfoDatCount
                let feelsLike = oneDayinfoData.map{$0.main.feelsLike}.reduce(0,+) / oneDaytInfoDatCount
                let humidty = oneDayinfoData.map{Double($0.main.humidity)}.reduce(0,+) / oneDaytInfoDatCount
                let windSpeed = oneDayinfoData.map{$0.wind.speed}.reduce(0,+) / oneDaytInfoDatCount
                let windDeg = oneDayinfoData.map{Double($0.wind.deg)}.reduce(0,+) / oneDaytInfoDatCount
                let description = oneDayinfoData[0].weather[0].description
                let icon = oneDayinfoData[0].weather[0].icon
                var rainFall = 0.0
                for threeHourDayInfo in oneDayinfoData{
                    let threeHoureRainFall = threeHourDayInfo.rain?.rain3H == nil ? 0.0 : threeHourDayInfo.rain?.rain3H
                    rainFall+=threeHoureRainFall!
                }
                rainFall /= oneDaytInfoDatCount
                OneDayAverageDataList.append(OneDayAverageData(date: date, temp: temp, tempMax: tempMax, tempMin: tempMin, feelsLike: feelsLike, humidty: Int(humidty), windSpeed: windSpeed, windDeg: windDeg, rainfall: rainFall, description: description, icon: icon))
            }
            completion(OneDayAverageDataList,cityName)
        }
    }
    func getOneDaySplitForecastData(coordinate : Coordinate, completion : @escaping([[List]],String) -> Void) { // Day별로 데이터 분리
        getWeeklyForecastData(from: coordinate) { weeklyForecastData in
            let cityName = weeklyForecastData.city.name
            var oneDaySplitForecastData = [[List]]()
            let dateArr = Set(weeklyForecastData.list.map{$0.dtTxt.split(separator: " ").map{String($0)}[0]})
            for date in dateArr.sorted(){
                let tempWeeklyForecastData = weeklyForecastData.list.filter { list in
                    list.dtTxt.split(separator: " ").map{String($0)}.first! == date
                }
                oneDaySplitForecastData.append(tempWeeklyForecastData)
            }
            completion(oneDaySplitForecastData,cityName)
        }
    }
}
