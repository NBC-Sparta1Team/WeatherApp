//
//  CollectionViewCell.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/14/24.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    static let identi = "CollectionViewCell"
    
    // 지역 이름 레이블 추가
    private lazy var  locationLabel  : UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = UIFont.boldSystemFont(ofSize: 25)
        locationLabel.textColor = UIColor(named: "textColor")
        return locationLabel
        
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 15)
        descriptionLabel.textColor = UIColor(named: "textColor")
        return descriptionLabel
    }()

    
    private lazy var temperatureLabel  : UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 15)
        temperatureLabel.textAlignment = .right
        temperatureLabel.textColor = UIColor(named: "textColor")
        return temperatureLabel
    }()
    private lazy var averageTemperatureLabel  : UILabel = {
        let averageTemperatureLabel = UILabel()
        averageTemperatureLabel.textAlignment = .right
        averageTemperatureLabel.font = UIFont.boldSystemFont(ofSize: 25)
        averageTemperatureLabel.textColor = UIColor(named: "textColor")
        return averageTemperatureLabel
    }()
    private lazy var iconImage : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "backgroundColor")
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.addSubview(averageTemperatureLabel)
        self.contentView.addSubview(temperatureLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(locationLabel)
        self.contentView.addSubview(iconImage)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        averageTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            averageTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            averageTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            iconImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            iconImage.trailingAnchor.constraint(equalTo: averageTemperatureLabel.leadingAnchor, constant: -10),
            iconImage.heightAnchor.constraint(equalToConstant: 50),
            iconImage.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setCell(model : ForecastInfoModel){
        print()
        locationLabel.text = model.name
        averageTemperatureLabel.text = TempStateData.shared.state ? "\(Int(model.main.temp))°C" : model.main.temp.setFahrenheit()
        let max = TempStateData.shared.state ? "\(Int(model.main.tempMax))°C" : model.main.tempMax.setFahrenheit()
        let min = TempStateData.shared.state ? "\(Int(model.main.tempMin))°C" : model.main.tempMin.setFahrenheit()
        temperatureLabel.text = "최저: \(min)  최고: \(max)"
        descriptionLabel.text = "\(model.weather.first!.description)"
        if let url = URL(string: "https://openweathermap.org/img/wn/\(model.weather.first!.icon)@2x.png" ){
            iconImage.load(url: url)
        }
    }
}
