//
//  UIImageView+Extension.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/13/24.
//

import Foundation
import UIKit
extension UIImageView {
    func load(url: URL) {  // URL -> UIImage 함수
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
