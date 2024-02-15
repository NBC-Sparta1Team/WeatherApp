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
    func getWeeklyAverageData(from coordinate : Coordinate ,completion : @escaping([OneDayAverageData],City)->Void){ // 3hour/day 평균 날씨 정보
        var OneDayAverageDataList : [OneDayAverageData] = []
        
        getOneDaySplitForecastData(coordinate: coordinate) { oneDaySplitForecastDataList,city  in
            
            for oneDayinfoData in oneDaySplitForecastDataList{
                
                let date = oneDayinfoData[0].dtTxt.split(separator: " ").map{String($0)}.first!
                let oneDaytInfoDatCount = Double(oneDayinfoData.count)
                let temp = oneDayinfoData.map{$0.main.temp}.reduce(0, +) / oneDaytInfoDatCount
                let tempMax = oneDayinfoData.map{$0.main.tempMax}.reduce(0, +) / oneDaytInfoDatCount
                let tempMin = oneDayinfoData.map{$0.main.tempMin}.reduce(0, +) / oneDaytInfoDatCount
                let feelsLike = oneDayinfoData.map{$0.main.feelsLike}.reduce(0,+) / oneDaytInfoDatCount
                let humidty = oneDayinfoData.map{Double($0.main.humidity)}.reduce(0,+) / oneDaytInfoDatCount
                let windSpeed = oneDayinfoData.map{$0.wind.speed}.reduce(0,+) / oneDaytInfoDatCount
                let windGust = oneDayinfoData.map{Double($0.wind.gust ?? 0)}.reduce(0,+) / oneDaytInfoDatCount
                let windDeg = oneDayinfoData.map{Double($0.wind.deg)}.reduce(0,+) / oneDaytInfoDatCount
                let visibility = oneDayinfoData.map{Double($0.visibility)}.reduce(0,+) / oneDaytInfoDatCount
                let wind = Wind(speed: windSpeed, deg: Int(windDeg), gust: windGust)
                let weather = oneDayinfoData.first!.weather
                var rainFall = 0.0
                for threeHourDayInfo in oneDayinfoData{
                    let threeHoureRainFall = threeHourDayInfo.rain?.rain3H == nil ? 0.0 : threeHourDayInfo.rain?.rain3H
                    rainFall+=threeHoureRainFall!
                }
                rainFall /= oneDaytInfoDatCount
                OneDayAverageDataList.append(OneDayAverageData(date: date, temp: temp, tempMax: tempMax, tempMin: tempMin, feelsLike: feelsLike, humidty: Int(humidty),wind: wind ,rainfall: rainFall, visibility: Int(visibility),weather: weather))
            }
            completion(OneDayAverageDataList,city)
        }
    }
    func getOneDaySplitForecastData(coordinate : Coordinate, completion : @escaping([[List]],City) -> Void) { // Day별로 데이터 분리
        getWeeklyForecastData(from: coordinate) { weeklyForecastData in
            let cityName = weeklyForecastData.city
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
    func getOneDay3HourForecastData(coordinate : Coordinate,completion :@escaping([OneDay3HourDataModel]) -> Void) { // 1day /3hout
        getWeeklyForecastData(from: coordinate) { weeklyForecastData in
            var dataList = [OneDay3HourDataModel]()
            let dateArr = Set(weeklyForecastData.list.map{$0.dtTxt.split(separator: " ").map{String($0)}[0]}).sorted()
            let date = dateArr.first!
            let oneDay3HourForecastDataList = weeklyForecastData.list.filter { list in
                list.dtTxt.split(separator: " ").map{String($0)}.first! == date
            }
            for oneDay3HourForecastData in oneDay3HourForecastDataList{
                let temp = oneDay3HourForecastData.main.temp
                let icon = oneDay3HourForecastData.weather.first!.icon
                let hour = oneDay3HourForecastData.dtTxt.split(separator: " ").last!.split(separator: ":").first!
                
                dataList.append(OneDay3HourDataModel(hour: String(hour), icon: icon, temp: temp))
            }
            completion(dataList)
        }
        
    }
}
