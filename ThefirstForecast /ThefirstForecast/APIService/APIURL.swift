//
//  APIBaseURL.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/6/24.
//

import Foundation
enum EndPoint{
    case geo(APItype : String)
    case data(APItype : String)
    var url : URL {
        switch self{
        case .geo(let APItype):
            return .makeForEndpoint(endPoint: "geo/1.0/\(APItype)")
        case .data(let APItype):
            return .makeForEndpoint(endPoint: "data/2.5/\(APItype)")
        }
    }
}
private extension URL{
    static let baseURL = "https://api.openweathermap.org/"
    static func makeForEndpoint(endPoint : String) -> URL{
        URL(string: baseURL + endPoint)!
    }
}
