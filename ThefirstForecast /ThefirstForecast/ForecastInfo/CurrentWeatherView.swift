//
//  CurrentWeatherView.swift
//  ThefirstForecast
//
//  Created by t2023-m0026 on 2/7/24.
//

import UIKit

class CurrentWeatherView : UIView {
    private let locationLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .regular)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 10.0
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        return label
    }()
    
    private let dailyTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 95, weight: .thin)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 10.0
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        return label
    }()
    
    private let weatherLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 10.0
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        return label
    }()
    
    private let temperatureMaxMinLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .regular)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 10.0
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
//    // superview가 없어서 그런지 가장 마지막에 layoutSubviews 이후에 크기가 지정됨
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print(#function)
//        frame = CGRect(x: 0, y: 0, width: Int(superview?.frame.width ?? 0), height: Int(superview?.frame.height ?? 0)/4)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    func addSubViewsInCurrentWeatherView() {
        addSubViews([
            locationLabel,
            dailyTemperatureLabel,
            weatherLabel,
            temperatureMaxMinLabel
        ])
    }
    
    func autoLayoutCurrentWeatherView() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureMaxMinLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            dailyTemperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 13),
            dailyTemperatureLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            
            weatherLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: dailyTemperatureLabel.bottomAnchor, constant: 5),
            
            temperatureMaxMinLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            temperatureMaxMinLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 5),
            temperatureMaxMinLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)

        ])
    }
    
    func setCurrentWeatherLabels(model : ForecastInfoModel) {
        locationLabel.text = model.name
        dailyTemperatureLabel.text = "\(Int(model.main.temp))°"
        weatherLabel.text = "\(model.weather.first!.description)"
        let min = String(format: "최고 : %d°", Int(model.main.tempMin))
        let max = String(format: "최저 : %d°", Int(model.main.tempMax))
        temperatureMaxMinLabel.text = "\(min) \(max)"
    
    }
}
