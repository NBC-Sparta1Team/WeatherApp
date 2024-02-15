//
//  String+Extension.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/15/24.
//

extension Double{
    func setFahrenheit() ->String{
        let text = Int((self * 1.8) + 32)
        return String(text) + "°F"
    }
}
