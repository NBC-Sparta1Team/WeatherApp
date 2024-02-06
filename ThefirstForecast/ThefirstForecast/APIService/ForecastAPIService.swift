//
//  APIService.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import Foundation
class ForecastAPIService{
    static let shared = ForecastAPIService()
    let APIKey = Bundle.main.infoDictionary?["OpenWeatherMap_KEY"] as? String
    func convertName(eng : String) -> String{
        switch eng{
        case "서울","서울특별시" : return "Seoul"
        case "광주광역시","광주" : return "Gwangju"
        case "대구광역시","대구": return "Daegu"
        case "대전광역시" : return  "Daejeon"
        case "부산광역시" : return  "Busan"
        case "울산광역시" : return  "Ulsan"
        case "인천광역시" : return  "Incheon"
        case "강원도" : return  "Gangwon-do"
        case "경기도" : return  "Gyeonggi-do"
        case "경상북도" : return "Gyeongsangbuk-do"
        case "경상남도" : return "Gyeongsangnam-do"
        case "전라북도" : return "Jeollabuk-do"
        case "전라남도" : return "Jeollanam-do"
        case "충청북도" : return "Chungcheongbuk-do"
        case "충청남도" : return "Chungcheongnam-do"
        default:
            return "우편 번호를 이용하세요."
        }
    }
    func getCoordinate(fromCityDoName cityDoName : String, completion : @escaping(CityCoordinateModel) -> Void){
        guard let baseURL = URL(string: "http://api.openweathermap.org/geo/1.0/direct") else {
            print("Error : URL")
            return
        }
        let cityDoName = self.convertName(eng: cityDoName) // 특별시,광역시, ~도
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "q", value: "\(cityDoName),kr"),URLQueryItem(name: "limit", value: "5"),URLQueryItem(name: "appid", value: APIKey)]
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
                let coordianteData : [CityCoordinateModel] = try JSONDecoder().decode([CityCoordinateModel].self, from: data)
                completion(coordianteData.first!)
            }catch{
                print("Decoding Error : \(String(describing: error.localizedDescription))")
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
        }.resume()
    }
    
    func getCoordinate(fromZipcode zipCode : String, completion : @escaping(ZipCodeModel) -> Void){
        guard let baseURL = URL(string: "http://api.openweathermap.org/geo/1.0/zip") else {
            print("Error : URL")
            return
        }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
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
                let coordianteData : ZipCodeModel = try JSONDecoder().decode(ZipCodeModel.self, from: data)
                completion(coordianteData)
            }catch{
                print("Decoding Error : \(String(describing: error.localizedDescription))")
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code : \(httpResponse.statusCode)")
            }
        }.resume()
    }
    func getForecastData(from coordinate : Coordinate,completion : @escaping(ForecastInfoModel)->Void){
        guard let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/weather") else {
            print("Error : URL")
            return
        }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "lat", value: "\(coordinate.lat)"),URLQueryItem(name: "lon", value: "\(coordinate.lon)"),URLQueryItem(name: "appid", value: APIKey),URLQueryItem(name: "lang", value: "kr")]
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
                print("Decoding Error : \(String(describing: error.localizedDescription))")
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code : \(httpResponse.statusCode)")
            }
        }.resume()
    }
}
