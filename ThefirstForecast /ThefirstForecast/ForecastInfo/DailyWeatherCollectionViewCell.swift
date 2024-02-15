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
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setCollectionViewCell(model : OneDay3HourDataModel) {
        timeLabel.text = model.hour + "시"
        if let url = URL(string: "https://openweathermap.org/img/wn/\(model.icon)@2x.png"){
            weatherImage.load(url: url)
        }
        let temp = TempStateData.shared.state ? "\(Int(model.temp))°C" : model.temp.setFahrenheit()
        hourlyTemperatureLabel.text = temp
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
