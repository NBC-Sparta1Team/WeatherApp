//
//  ViewController.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit

class TabBarController: UITabBarController {
    let firstVC = UINavigationController.init(rootViewController: MainVC())
    let secondVC = UINavigationController.init(rootViewController: WeeklyForecastVC())
    let thirdVC = ForecastInfoVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }

    private func setTabBar(){
        self.viewControllers = [firstVC,secondVC,thirdVC]
        firstVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "HomeImg"), tag: 1)
        secondVC.tabBarItem = UITabBarItem(title: "주간 예보", image: UIImage(named: "WeeklyForecastImg"), tag: 2)
        thirdVC.tabBarItem = UITabBarItem(title: "날씨 정보", image: UIImage(systemName: "cloud"), tag: 3)
       
    }
}

