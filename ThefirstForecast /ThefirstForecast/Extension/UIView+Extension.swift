//
//  UIView+Extension.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/14/24.
//

import UIKit
extension UIView {
    func addSubViews(_ views : [UIView]){
        _ = views.map{self.addSubview($0)}
    }
}
