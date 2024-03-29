//
//  APIService.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import Foundation
class ForecastAPIManger{
    static let shared = ForecastAPIManger()
    let APIKey = Bundle.main.infoDictionary?["OpenWeatherMap_KEY"] as? String
    private func convertName(eng : String) -> String{ // 한글 입력 -> 영문 변환
        switch eng{
        case "서울특별시","서울" : return "Seoul"
        case "광주광역시","광주" : return "Gwangju"
        case "대구광역시","대구" : return "Daegu"
        case "대전광역시","대전" : return  "Daejeon"
        case "부산광역시","부산" : return  "Busan"
        case "울산광역시","울산" : return  "Ulsan"
        case "인천광역시","인천" : return  "Incheon"
        case "강원도" : return  "Gangwon-do"
        case "경기도" : return  "Gyeonggi-do"
        case "경상북도" : return "Gyeongsangbuk-do"
        case "경상남도" : return "Gyeongsangnam-do"
        case "전라북도" : return "Jeollabuk-do"
        case "전라남도" : return "Jeollanam-do"
        case "충청북도" : return "Chungcheongbuk-do"
        case "충청남도" : return "Chungcheongnam-do"
        default:
            return eng
        }
    }
    func getForecastData(fromCityDoName cityDoName : String, completion : @escaping(ForecastInfoModel?,Bool) -> Void){ // 대표 행정 구역 이름 -> 날씨 정보 데이터 API
        let url = EndPoint.data(APItype: "weather").url
        let cityDoName = self.convertName(eng: cityDoName) // 특별시,광역시, ~도
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "q", value: "\(cityDoName),kr"),URLQueryItem(name: "appid", value: APIKey),URLQueryItem(name: "lang", value: "kr"),URLQueryItem(name: "units", value: "metric")]
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
                let forecastData : ForecastInfoModel = try JSONDecoder().decode(ForecastInfoModel.self, from: data)
                
                completion(forecastData,true)
            }catch{
                print("Decoding Error getCoordinate : \(String(describing: error.localizedDescription))")
                completion(nil,false)
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
        }.resume()
        
    }
    
    func getCoordinate(fromZipcode zipCode : String, completion : @escaping(Coordinate) -> Void){ // 우편번호-> 좌표 API
        let url = EndPoint.geo(APItype: "zip").url
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "zip", value: "\(zipCode),kr"),URLQueryItem(name: "appid", value: APIKey)]
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
                let coordianteData : CoordinateModel = try JSONDecoder().decode(CoordinateModel.self, from: data)
                
                completion(Coordinate(lat: coordianteData.lat, lon: coordianteData.lon))
            }catch{
                print("Decoding Error getCoordinate: \(String(describing: error.localizedDescription))")
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code : \(httpResponse.statusCode)")
            }
        }.resume()
    }
    func getForecastData(from coordinate : Coordinate,completion : @escaping(ForecastInfoModel)->Void){ //좌표 -> 날씨 데이터 API
        guard let lat = coordinate.lat else {return}
        guard let lon = coordinate.lon else {return}
        let url = EndPoint.data(APItype: "weather").url
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
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
                let forecastData : ForecastInfoModel = try JSONDecoder().decode(ForecastInfoModel.self, from: data)
                completion(forecastData)
            }catch{
                print("Decoding Error getForecastData : \(String(describing: error.localizedDescription))")
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code getForecastData : \(httpResponse.statusCode)")
            }
        }.resume()
    }
    func SynthesizeGetCoodinateData(from input : String, completion : @escaping(ForecastInfoModel?,Bool)->Void){
        if divisionType(Input: input){ // 우편번호 -> 좌표 -> 날씨 데이터
            getCoordinate(fromZipcode: input) { getCoordinateData in
                self.getForecastData(from: getCoordinateData) { getForecastData in
                    completion(getForecastData,true)
                }
            }
        }else{ // 도시이름 -> 날씨데이터
            getForecastData(fromCityDoName: input) { getForecastData,status  in
                completion(getForecastData,status)
            }
        }
    }
    func divisionType(Input : String)-> Bool{ // false : 도시 이름 , true : 우편번호
        for i in Input{
            if !i.isNumber{
                return false
            }
        }
        return true
    }
}
