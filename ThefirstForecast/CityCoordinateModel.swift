//
//  CityCoordianteModel.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/6/24.
//

import Foundation
struct CityCoordinateModel : Decodable{
    let name: String
    let lat, lon: Double
}
