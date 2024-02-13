//
//  CurrentCoordinateModel.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/13/24.
//

import Foundation
class CurrentCoordinateModel {
    static let shared = CurrentCoordinateModel()
    
    
    var currentCoordinate = Coordinate(lat: 0.0, lon: 0.0)
    
    private init() {}
}
