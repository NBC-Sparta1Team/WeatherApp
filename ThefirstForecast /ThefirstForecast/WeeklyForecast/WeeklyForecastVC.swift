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
    var currentCityLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    var weatherForecasts: [OneDayAverageData] = []
    var city : City?
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLoaction()
        setNavigationBarButtonItem()
        setWeeklyTableView()
        self.view.backgroundColor = .white
        view.addSubview(currentCityLabel)
        view.addSubview(weeklyTableView)
        currentCityLabel.translatesAutoresizingMaskIntoConstraints = false
        weeklyTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentCityLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            currentCityLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            currentCityLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            weeklyTableView.topAnchor.constraint(equalTo: currentCityLabel.bottomAnchor, constant: 10),
            weeklyTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            weeklyTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            weeklyTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    private func setWeeklyTableView(){
        weeklyTableView = UITableView(frame: view.bounds, style: .plain)
        weeklyTableView.backgroundColor = .white
        weeklyTableView.dataSource = self
        weeklyTableView.delegate = self
        weeklyTableView.separatorStyle = .none
        weeklyTableView.showsVerticalScrollIndicator = false
        weeklyTableView.register(WeeklyForecastTableViewCell.self, forCellReuseIdentifier: "WeeklyForecastTableViewCell")
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
        let celsiusAction = UIAlertAction(title: "섭씨", style: .default) { _ in
            TempStateData.shared.state = true
            self.weeklyTableView.reloadData()
            print("섭씨 선택")
        }
        let fahrenheitAction = UIAlertAction(title: "화씨", style: .default) { _ in
            TempStateData.shared.state = false
            self.weeklyTableView.reloadData()
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
        cell.dateLabel.text = weatherForecasts[indexPath.row].date.replacingOccurrences(of: "-", with: ".")
        cell.selectionStyle = .none
        let temp = TempStateData.shared.state ? "\(Int(weatherForecasts[indexPath.row].temp))°C" : weatherForecasts[indexPath.row].temp.setFahrenheit()
        let max = TempStateData.shared.state ? "\(Int(weatherForecasts[indexPath.row].tempMax))°C" : weatherForecasts[indexPath.row].tempMax.setFahrenheit()
        let min = TempStateData.shared.state ? "\(Int(weatherForecasts[indexPath.row].tempMin))°C" : weatherForecasts[indexPath.row].tempMin.setFahrenheit()
        cell.averageTemperatureLabel.text = "\(temp)"
        cell.minTemperatureLabel.text = "최저 : \(min)"
        cell.maxTemperatureLabel.text = "최고 : \(max)"
        cell.precipitationLabel.text = "강수량 : \(Int(weatherForecasts[indexPath.row].rainfall)) m/s"
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
        vc.fourForecastData.append(FourForecastStatusModel(title: "체감온도", value: Int(main.feelsLike), icon: "thermometer.medium"))
        vc.fourForecastData.append(FourForecastStatusModel(title: "강수량", value: Int(data.rainfall), icon: "drop.fill"))
        vc.fourForecastData.append(FourForecastStatusModel(title: "가시거리", value: data.visibility, icon: "eye.fill"))
        vc.fourForecastData.append(FourForecastStatusModel(title: "습도", value: data.humidty, icon: "humidity"))
        vc.windy = wind
        vc.modalPresentationStyle = .fullScreen
        vc.presentView = 1
        vc.selectDate = data.date
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
                self.currentCityLabel.text = cityInfo.name
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

