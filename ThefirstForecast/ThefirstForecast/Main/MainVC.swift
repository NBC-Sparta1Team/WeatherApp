//
//  MainVC.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        WeatherMapAPIManger.shared.getCoordinate(from: "서울") { coodinateData in
            print(coodinateData)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
