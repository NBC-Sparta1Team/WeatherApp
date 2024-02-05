//
//  DailyWeatherCollectionViewCell.swift
//  ThefirstForecast
//
//  Created by t2023-m0026 on 2/5/24.
//

import UIKit

class DailyWeatherCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "dailyWeatherCollectionViewCell"
    
    private let timeLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let windLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let hourlyTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    func setCollectionViewCell(time: String, wind: String, temperature: String) {
        addSubViews()
        autoLayout()
        timeLabel.text = time
        windLabel.text = wind
        hourlyTemperatureLabel.text = temperature
    }
    
    private func addSubViews() {
        self.contentView.addSubViews([
        timeLabel,
        windLabel,
        hourlyTemperatureLabel
        ])
    }
    
    private func autoLayout() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        hourlyTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            windLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            windLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            
            hourlyTemperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 3),
            hourlyTemperatureLabel.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 10)
        ])
    }
}
