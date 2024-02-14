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
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let weatherImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let hourlyTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    func setCollectionViewCell(time: String, icon: UIImage, temperature: String) {
        addSubViews()
        autoLayout()
        timeLabel.text = time
        weatherImage.image = icon
        hourlyTemperatureLabel.text = temperature
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
            weatherImage.widthAnchor.constraint(equalToConstant: 50),
            weatherImage.heightAnchor.constraint(equalToConstant: 50),
            
            hourlyTemperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 3),
            hourlyTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(contentView.bounds.height / 6)),
        ])
    }
}
