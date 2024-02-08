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
        label.textColor = .white
        return label
    }()
    
    private let weatherImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        return image
    }()
    
    private let hourlyTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    func setCollectionViewCell(time: String, wind: String, temperature: String) {
        addSubViews()
        autoLayout()
        timeLabel.text = time
        weatherImage.image = UIImage(systemName: "cloud.sun.rain")
        hourlyTemperatureLabel.text = temperature
//        self.contentView.backgroundColor = UIColor(
//            red: drand48(), green: drand48(), blue: drand48(), alpha: drand48()
//        )
    }
    
    private func addSubViews() {
        self.contentView.addSubViews([
        timeLabel,
        weatherImage,
        hourlyTemperatureLabel
        ])
    }
    
    private func autoLayout() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        hourlyTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height / 6),
            
            weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            
            hourlyTemperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 3),
            hourlyTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(contentView.bounds.height / 6)),
        ])
    }
}
