//
//  CollectionViewCell.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/14/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let identi = "CollectionViewCell"
    
    // 지역 이름 레이블 추가
    private lazy var  locationLabel  : UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return locationLabel
        
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        return descriptionLabel
    }()

    
    private lazy var temperatureLabel  : UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.font = UIFont.systemFont(ofSize: 14)
        temperatureLabel.textAlignment = .right
        temperatureLabel.font = UIFont.systemFont(ofSize: 14)
        return temperatureLabel
    }()
    private lazy var averageTemperatureLabel  : UILabel = {
        let averageTemperatureLabel = UILabel()
        averageTemperatureLabel.textAlignment = .right
        averageTemperatureLabel.font = UIFont.systemFont(ofSize: 14)
        return averageTemperatureLabel
    }()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.contentView.addSubview(averageTemperatureLabel)
        self.contentView.addSubview(temperatureLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(locationLabel)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        averageTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            averageTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            averageTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setCell(model : ForecastInfoModel){
        locationLabel.text = model.name
        averageTemperatureLabel.text = "\(model.main.temp)°"
        let min = String(format: "%.1f", model.main.tempMin)
        let max = String(format: "%.1f", model.main.tempMax)
        temperatureLabel.text = "최저: \(min)°  최고: \(max)°"
        descriptionLabel.text = "\(model.weather.first!.description)"
    }
}
