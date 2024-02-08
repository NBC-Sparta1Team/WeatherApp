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
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    

    let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 9)
        return label
    }()
    
    let maxTemperatureLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 9)
        return label
    }()
    
    let averageTemperatureLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let precipitationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 9)
        return label
    }()
    let weatherIconImageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 25, bottom: 20, right: 25))
               contentView.layer.cornerRadius = 8
               contentView.layer.masksToBounds = true
        
        
       
       }
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        // Initialization code
        contentView.backgroundColor = .lightGray
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
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.topAnchor.constraint(equalTo: averageTemperatureLabel.bottomAnchor, constant: 10).isActive = true
        minTemperatureLabel.trailingAnchor.constraint(equalTo: maxTemperatureLabel.leadingAnchor, constant: -5).isActive = true
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.topAnchor.constraint(equalTo: averageTemperatureLabel.bottomAnchor, constant: 10).isActive = true
        maxTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        averageTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        averageTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        averageTemperatureLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: 5).isActive = true
        averageTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        precipitationLabel.translatesAutoresizingMaskIntoConstraints = false
        precipitationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        precipitationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        weatherIconImageView.trailingAnchor.constraint(equalTo: averageTemperatureLabel.leadingAnchor, constant: -5).isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}




