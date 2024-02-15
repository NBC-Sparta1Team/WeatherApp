//
//  5DaysForecastVC.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit
import CoreLocation
class WeeklyForecastVC: UIViewController {
    var weeklyTableView: UITableView!
    var locationManager =  CLLocationManager()
    
    var weatherForecasts: [OneDayAverageData] = []
    var city : City?
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLoaction()
        setNavigationBarButtonItem()
        self.view.backgroundColor = .white
        
      
        
        
        weeklyTableView = UITableView(frame: view.bounds, style: .plain)
        
        weeklyTableView.backgroundColor = .white
        weeklyTableView.dataSource = self
        weeklyTableView.delegate = self
        weeklyTableView.separatorStyle = .none
        weeklyTableView.showsVerticalScrollIndicator = false
        weeklyTableView.register(WeeklyForecastTableViewCell.self, forCellReuseIdentifier: "WeeklyForecastTableViewCell")
        view.addSubview(weeklyTableView)
        
        weeklyTableView.translatesAutoresizingMaskIntoConstraints = false
  
        
        
        weeklyTableView.reloadData()
        
    }
    
    private func setNavigationBarButtonItem(){
        let weatherBarbuttonItem = UIBarButtonItem(title: "주간 예보", style: .plain, target:self, action: nil) //날씨버튼
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingButtonTapped)) //설정버튼
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30.0),NSAttributedString.Key.foregroundColor : UIColor.black] // 날씨 글자 Font크키와 색상변경을 위함
        weatherBarbuttonItem.setTitleTextAttributes(attributes, for: .normal)
        settingButton.tintColor = .black // Button Color
        
        navigationItem.leftBarButtonItem = weatherBarbuttonItem
        navigationItem.rightBarButtonItem = settingButton
    }
    
    
    @objc func settingButtonTapped() {
        let alertController = UIAlertController(title: "온도 단위 선택", message: "원하는 단위를 선택하세요.", preferredStyle: .actionSheet)
        
        let celsiusAction = UIAlertAction(title: "섭씨", style: .default) { action in
            // 섭씨 선택 시 처리할 동작 추가
            print("섭씨 선택")
        }
        
        let fahrenheitAction = UIAlertAction(title: "화씨", style: .default) { action in
            // 화씨 선택 시 처리할 동작 추가
            print("화씨 선택")
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(celsiusAction)
        alertController.addAction(fahrenheitAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension WeeklyForecastVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyForecastTableViewCell", for: indexPath)
        as! WeeklyForecastTableViewCell
        cell.dateLabel.text = weatherForecasts[indexPath.row].date
        cell.selectionStyle = .none
        cell.minTemperatureLabel.text = "최저 : \(String(format: "%.1f", weatherForecasts[indexPath.row].tempMin))°"
        cell.maxTemperatureLabel.text = "최고 : \(String(format: "%.1f", weatherForecasts[indexPath.row].tempMax)) °"
        cell.averageTemperatureLabel.text = "\(String(format: "%.1f", weatherForecasts[indexPath.row].temp)) °"
        cell.precipitationLabel.text = "강수량 : \(String(format: "%.3f", weatherForecasts[indexPath.row].rainfall)) m/s"
        if let url = URL(string: "https://openweathermap.org/img/wn/\(weatherForecasts[indexPath.row].weather.first!.icon)@2x.png"){
            cell.weatherIconImageView.load(url: url)
        }
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ForecastInfoVC()
        let data = weatherForecasts[indexPath.row]
        let main = Main(temp: data.temp, feelsLike: data.feelsLike, tempMin: data.tempMin, tempMax: data.tempMax, humidity: data.humidty)
        let wind = data.wind
        let rain = Rain(rain3H: nil, rain1H: data.rainfall)
        
        vc.forecastInfo = ForecastInfoModel(coord: self.city!.coord, weather: data.weather, main:main , visibility: data.visibility, wind: wind, rain: rain , name: self.city!.name)
        vc.fourForecastData.append(FourForecastStatusModel(title: "체감온도", value: "\(String(describing: main.feelsLike))°", icon: "thermometer.medium"))
        vc.fourForecastData.append(FourForecastStatusModel(title: "강수량", value: "\(String(describing: data.rainfall ))mm/h", icon: "drop.fill"))
        vc.fourForecastData.append(FourForecastStatusModel(title: "가시거리", value: "\(String(describing: data.visibility))m", icon: "eye.fill"))
        vc.fourForecastData.append(FourForecastStatusModel(title: "습도", value: "\(String(describing: data.humidty))%", icon: "humidity"))
        vc.windy = wind
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: true)
    }
}

extension WeeklyForecastVC: UITableViewDelegate {
    //畫幾次
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



extension WeeklyForecastVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        CurrentCoordinateModel.shared.currentCoordinate = Coordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        WeeklyForecastAPIManger.shred.getWeeklyAverageData(from: CurrentCoordinateModel.shared.currentCoordinate) { oneDayAverageData,cityInfo in
            DispatchQueue.main.async {
                self.weatherForecasts = oneDayAverageData
                self.city = cityInfo
                self.weeklyTableView.reloadData()
            }
        }
    }
    func getCurrentLoaction(){
        locationManager = CLLocationManager()// CLLocationManager클래스의 인스턴스 locationManager를 생성
        locationManager.delegate = self// 포그라운드일 때 위치 추적 권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest// 배터리에 맞게 권장되는 최적의 정확도
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()// 위치 업데이트
    }
}

