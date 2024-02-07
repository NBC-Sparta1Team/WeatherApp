//
//  WeatherView.swift
//  ThefirstForecast
//
//  Created by t2023-m0026 on 2/7/24.
//

import UIKit

class WeatherView: UIView {
    private let windSpeedScale : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let windLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let windSpeed : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private let gustScale : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let gustLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let gustSpeed: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .regular)
        return label
    }()
    
    private let windDirection : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: Int(superview?.frame.width ?? 0), height: Int(superview?.frame.height ?? 0)/4)
        print("\(self.frame)")
        addCurrentWeatherSubViews()
        autoLayoutCurrentWeatherView()
        setCurrentWeatherLabels()
        backgroundColor = .systemGray6
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
    
    func addCurrentWeatherSubViews() {
        addSubViews([
            windSpeedScale,
            windLabel,
            windSpeed,
            gustScale,
            gustLabel,
        ])
        print(#function)
    }
    
    func autoLayoutCurrentWeatherView() {
        windSpeedScale.translatesAutoresizingMaskIntoConstraints = false
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeed.translatesAutoresizingMaskIntoConstraints = false
        gustScale.translatesAutoresizingMaskIntoConstraints = false
        gustLabel.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            windSpeedScale.centerXAnchor.constraint(equalTo: centerXAnchor),
            windSpeedScale.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            
            windLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 13),
            windLabel.topAnchor.constraint(equalTo: windSpeedScale.bottomAnchor, constant: 10),
            
            windSpeed.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            windSpeed.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 10),
            
            gustScale.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -40),
            gustScale.topAnchor.constraint(equalTo: windSpeed.bottomAnchor, constant: 10),
            
            gustLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 40),
            gustLabel.topAnchor.constraint(equalTo: windSpeed.bottomAnchor, constant: 10),
        ])
        print(#function)
    }
    
    func setCurrentWeatherLabels() {
        windSpeedScale.text = "나의 위치"
        windLabel.text = "6°"
        windSpeed.text = "바람"
        gustScale.text = "최고 : 6°"
        gustLabel.text = "최저 : 0°"
        print(#function)
    }
}
