//
//  ForecastInfoVC.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit

enum WeatherSection {
    case dailyWeather([Int])
    case dailyForecastInfo([String])
    case wind([String])
}

class ForecastInfoVC: UIViewController {
    
    let time = ["오전 0시", "오전 3시", "오전 6시", "오전 9시", "오전 12시", "오전 15시", "오전 18시", "오전 21시", "오전 24시"]
    
    let temperature = [3, 2, 1, 2, 5, 7, 5, 4, 3]
    
    private let locationLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .regular)
        return label
    }()
    
    private let dailyTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 64, weight: .regular)
        return label
    }()
    
    private let weatherLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let maxTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let minTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let apparentTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let humidityLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let windLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let rainLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let dailyWeatherCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 8
        collectionView.backgroundColor = .systemGray6
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        addSubviews()
        autoLayout()
        setLabels()
        dailyWeatherCollectionView.delegate = self
        dailyWeatherCollectionView.dataSource = self
        dailyWeatherCollectionView.reloadData()
    }
    


}

extension ForecastInfoVC {
    private func addSubviews() {
        view.addSubViews([
            locationLabel,
            dailyTemperatureLabel,
            weatherLabel,
            maxTemperatureLabel,
            minTemperatureLabel,
            dailyWeatherCollectionView
        ])
//        view.addSubViews([
//            apparentTemperatureLabel,
//            humidityLabel,
//            windLabel,
//            rainLabel
//            ])
        dailyWeatherCollectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier)
    }
    
    private func autoLayout() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
//        apparentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
//        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
//        windLabel.translatesAutoresizingMaskIntoConstraints = false
//        rainLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyWeatherCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            
            dailyTemperatureLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 13),
            dailyTemperatureLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            
            weatherLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: dailyTemperatureLabel.bottomAnchor, constant: 10),
            
            maxTemperatureLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -40),
            maxTemperatureLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 10),
            
            minTemperatureLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 40),
            minTemperatureLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 10),
            
//            apparentTemperatureLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            apparentTemperatureLabel.topAnchor.constraint(equalTo: maxTemperatureLabel.bottomAnchor, constant: 10),
//            
//            humidityLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            humidityLabel.topAnchor.constraint(equalTo: apparentTemperatureLabel.bottomAnchor, constant: 20),
//            
//            windLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            windLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 20),
//            
//            rainLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            rainLabel.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 20),
            
            dailyWeatherCollectionView.topAnchor.constraint(equalTo: maxTemperatureLabel.bottomAnchor, constant: 60),
            dailyWeatherCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dailyWeatherCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            dailyWeatherCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1 / 5)
        ])
    }
}

extension ForecastInfoVC {
    private func setLabels() {
        locationLabel.text = "나의 위치"
        dailyTemperatureLabel.text = "6°"
        weatherLabel.text = "바람"
        maxTemperatureLabel.text = "최고 : 6°"
        minTemperatureLabel.text = "최저 : 0°"
        apparentTemperatureLabel.text = "체감온도 : 5°"
        humidityLabel.text = """
                             습도
                             15%
                             """
        windLabel.text = "풍향 : 북서쪽 풍속 1m/s"
        rainLabel.text = """
                         강수량
                         10mm
                         """
    }
}

extension ForecastInfoVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numOfSection = 5
        print("Number of section : \(numOfSection)")
        return numOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of Items in section : \(temperature.count)")
        return temperature.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dailyWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as? DailyWeatherCollectionViewCell
        let time = time[indexPath.item]
        let index = temperature[indexPath.item]
        cell?.setCollectionViewCell(time: time, wind: "\(temperature[indexPath.item])", temperature: "\(temperature[indexPath.item])°")
        return cell ?? UICollectionViewCell()
    }
    
    
}

extension ForecastInfoVC : UICollectionViewDelegate {
    
}

extension ForecastInfoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4.5
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}

extension UIView {
    func addSubViews(_ views : [UIView]){
        _ = views.map{self.addSubview($0)}
    }
}
