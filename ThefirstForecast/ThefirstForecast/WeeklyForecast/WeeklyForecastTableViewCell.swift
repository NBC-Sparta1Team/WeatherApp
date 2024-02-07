//
//  WeeklyForecastTableViewCell.swift
//  ThefirstForecast
//
//  Created by 洪立妍 on 2/6/24.
//

import UIKit

class WeeklyForecastTableViewCell: UITableViewCell {
    
    let dateLabel = UILabel()
    let dayOfWeekLabel = UILabel()
    let minTemperatureLabel = UILabel()
    let maxTemperatureLabel = UILabel()
    let averageTemperatureLabel = UILabel()
    let precipitationLabel = UILabel()
    let weatherIconImageView = UIImageView()
    
    override func layoutSubviews() {
           super.layoutSubviews()
           contentView.layer.cornerRadius = 10
           contentView.layer.masksToBounds = true
       }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        // Initialization code
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(dayOfWeekLabel)
        contentView.addSubview(minTemperatureLabel)
        contentView.addSubview(maxTemperatureLabel)
        contentView.addSubview(averageTemperatureLabel)
        contentView.addSubview(precipitationLabel)
        contentView.addSubview(weatherIconImageView)
        
    
        
        // Add constraints
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
        dayOfWeekLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        dayOfWeekLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60).isActive = true
        minTemperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 240).isActive = true
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60).isActive = true
        maxTemperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 300).isActive = true
        averageTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        averageTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        averageTemperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 300).isActive = true
        precipitationLabel.translatesAutoresizingMaskIntoConstraints = false
        precipitationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60).isActive = true
        precipitationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        weatherIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 250).isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}




