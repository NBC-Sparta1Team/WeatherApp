//
//  WeeklyDataProcessing.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/6/24.
//

import Foundation
class WeeklyDataProcessing{
    static let shred = WeeklyDataProcessing()
    
    private init(){}
    func getWeeklyData(from cityName : String ,completion : @escaping([OneDayAverageData])->Void){
        var OneDayAverageDataList : [OneDayAverageData] = []
        self.getOneDaySplitForecastData(cityName: cityName) { oneDaySplitForecastDataList in
            for oneDayinfoData in oneDaySplitForecastDataList{
                let date = oneDayinfoData[0].dtTxt.split(separator: " ").map{String($0)}[0]
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
            completion(OneDayAverageDataList)
        }
    }
    func getOneDaySplitForecastData(cityName : String, completion : @escaping([[List]]) -> Void) {
        ForecastAPIManger.shared.getCoordinate(fromCityDoName: "\(cityName)") { coordinate in
            ForecastAPIManger.shared.getWeeklyForecastData(from: Coordinate(lat: coordinate.lat, lon: coordinate.lon)) { weeklyForecastData in
                var oneDaySplitForecastData = [[List]]()
                let dateArr = Set(weeklyForecastData.list.map{$0.dtTxt.split(separator: " ").map{String($0)}[0]})
                for date in dateArr.sorted(){
                    let tempWeeklyForecastData = weeklyForecastData.list.filter { list in
                        list.dtTxt.split(separator: " ").map{String($0)}[0] == date
                    }
                    oneDaySplitForecastData.append(tempWeeklyForecastData)
                }
                completion(oneDaySplitForecastData)
            }
        }
    }
}
