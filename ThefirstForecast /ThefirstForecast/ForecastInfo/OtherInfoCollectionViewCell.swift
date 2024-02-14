//
//  OtherInfoCollectionViewCell.swift
//  ThefirstForecast
//
//  Created by t2023-m0026 on 2/8/24.
//

import UIKit

class OtherInfoCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "otherInfoCell"
    
    private let weatherIcon : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    private let weatherValue : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let weatherDescription : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    func setOtherInfoCell(model : FourForecastStatusModel) {
        
        
        setBackgroundBlurOfInfoView(blurEffect: .regular)
        addSubViews()
        autoLayout()
        contentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        contentView.layer.cornerRadius = 15
        weatherIcon.image = UIImage(systemName: model.icon)
        titleLabel.text = model.title
        weatherValue.text = "\(model.value)"
//        weatherDescription.text = description
        weatherIcon.tintColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    private func setBackgroundBlurOfInfoView(blurEffect: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: blurEffect)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = self.bounds
        effectView.layer.cornerRadius = 15
        self.layer.cornerRadius = 15
        
        // clipsToBounds가 true일 때, EffectView에 cornerRadius 적용됨.
        effectView.clipsToBounds = true
        // blur처리된 뷰를 한 겹 올리는 것
        self.addSubview(effectView)
    }
    
    private func addSubViews() {
        self.contentView.addSubViews([
        titleLabel,
        weatherIcon,
        weatherValue,
        weatherDescription
        ])
    }
    
    private func autoLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherValue.translatesAutoresizingMaskIntoConstraints = false
        weatherDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            weatherIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 10),
            weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: weatherIcon.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 7),
            
            weatherValue.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 10),
            weatherValue.leadingAnchor.constraint(equalTo: weatherIcon.leadingAnchor),
            
            weatherDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            weatherDescription.leadingAnchor.constraint(equalTo: weatherIcon.leadingAnchor),
            weatherDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
}
