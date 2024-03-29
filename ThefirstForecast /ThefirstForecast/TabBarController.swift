//
//  ViewController.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit
import CoreLocation

class TabBarController: UITabBarController {
    let firstVC = UINavigationController.init(rootViewController: MainVC())
    let secondVC = UINavigationController.init(rootViewController: WeeklyForecastVC())
    var locationManager =  CLLocationManager()    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        getCurrentLoaction()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setTabBar(){
        self.viewControllers = [firstVC,secondVC]
        firstVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "HomeImg"), tag: 1)
        secondVC.tabBarItem = UITabBarItem(title: "주간 예보", image: UIImage(named: "WeeklyForecastImg"), tag: 2)
    }

}

extension TabBarController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // 현재 사용자 위치 받아오기
        let location = locations[locations.count - 1]
        CurrentCoordinateModel.shared.currentCoordinate = Coordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        
    }
    func getCurrentLoaction(){
        locationManager = CLLocationManager()// CLLocationManager클래스의 인스턴스 locationManager를 생성
        locationManager.delegate = self// 포그라운드일 때 위치 추적 권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest// 배터리에 맞게 권장되는 최적의 정확도
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()// 위치 업데이트
    }
}
