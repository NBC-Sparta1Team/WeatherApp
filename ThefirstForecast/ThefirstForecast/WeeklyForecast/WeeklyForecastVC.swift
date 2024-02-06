//
//  5DaysForecastVC.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit

class WeeklyForecastVC: UIViewController {
    
    var averageOneDayForecastList = [OneDayAverageData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        WeeklyDataProcessing.shred.getWeeklyData(from: "서울") { OneDayAverageDataList in
            print(OneDayAverageDataList)
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
