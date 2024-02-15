//
//  CommonData.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/15/24.
//

import Foundation
class TempStateData {
    static let shared = TempStateData()
    
    
    var state : Bool = true // true 섭씨 , false 화씨
    
    private init() {}
}
