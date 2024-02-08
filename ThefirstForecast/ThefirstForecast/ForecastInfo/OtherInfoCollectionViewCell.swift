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
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let weatherValue : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let weatherDescription : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    func setOtherInfoCell(icon: UIImage, title: String, value: String, description: String) {
        setBackgroundBlurOfInfoView(blurEffect: .regular)
        addSubViews()
        autoLayout()
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 15
        weatherIcon.image = UIImage(systemName: "cloud.sun.rain") ?? UIImage()
        titleLabel.text = title
        weatherValue.text = value
        weatherDescription.text = description
    }
    
    private func setBackgroundBlurOfInfoView(blurEffect: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: blurEffect)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = self.bounds
        print("otherInfoCell.bounds in", #function, ": \(self.bounds)")
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
            weatherIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            weatherIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            weatherIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 10),
            weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: weatherIcon.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 7),
            
            weatherValue.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 10),
            weatherValue.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            weatherDescription.topAnchor.constraint(equalTo: weatherValue.bottomAnchor, constant: 20),
            weatherDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
