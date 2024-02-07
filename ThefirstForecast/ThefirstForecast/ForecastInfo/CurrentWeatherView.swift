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
        label.font = .systemFont(ofSize: 28, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let dailyTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 64, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let weatherLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let maxTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let minTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
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
            maxTemperatureLabel,
            minTemperatureLabel,
        ])
        print(#function)
    }
    
    func autoLayoutCurrentWeatherView() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            
            dailyTemperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 13),
            dailyTemperatureLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            
            weatherLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: dailyTemperatureLabel.bottomAnchor, constant: 10),
            
            maxTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -40),
            maxTemperatureLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 10),
            
            minTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 40),
            minTemperatureLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 10),
        ])
        print(#function)
    }
    
    func setCurrentWeatherLabels() {
        locationLabel.text = "나의 위치"
        dailyTemperatureLabel.text = "6°"
        weatherLabel.text = "바람"
        maxTemperatureLabel.text = "최고 : 6°"
        minTemperatureLabel.text = "최저 : 0°"
        print(#function)
    }
}
