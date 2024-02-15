//
//  WeeklyForecastTableViewCell.swift
//  ThefirstForecast
//
//  Created by 洪立妍 on 2/6/24.
//

import UIKit

class WeeklyForecastTableViewCell: UITableViewCell {
   
    let dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    
    let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    let maxTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    let averageTemperatureLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    let precipitationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    let weatherIconImageView = UIImageView()
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15))
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = UIColor(named: "backgroundColor")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        contentView.layer.cornerRadius = 10
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(minTemperatureLabel)
        contentView.addSubview(maxTemperatureLabel)
        contentView.addSubview(averageTemperatureLabel)
        contentView.addSubview(precipitationLabel)
        contentView.addSubview(weatherIconImageView)
        // Add constraints
        NSLayoutConstraint.activate([
            averageTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            averageTemperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            precipitationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            precipitationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            minTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.leadingAnchor, constant: -5),
            maxTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            minTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            weatherIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:15),
            weatherIconImageView.leadingAnchor.constraint(equalTo: averageTemperatureLabel.trailingAnchor, constant: 10),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 40),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        averageTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        precipitationLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
     
        
   
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}




