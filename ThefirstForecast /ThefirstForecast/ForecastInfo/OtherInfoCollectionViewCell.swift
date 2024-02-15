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
    
    // MARK: description 추가
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
    
//    func setDescription(model : FourForecastStatusModel) {
//        switch model.title {
//        case "체감온도" :
//            switch Int(model.value) {
//            case 20... :
//                weatherDescription.text = feelsLike[0]
//            case 10...20 :
//                weatherDescription.text = feelsLike[0]
//            }
//        default:
//            <#code#>
//        }
//    }
    
    private let feelsLike = [
        "더위를 느낄 수 있는 날씨입니다.",                   // 20°C초과
        "적당한 날씨로, 외출하기 좋은 날씨입니다.",             // 10°C초과 20°C미만
        "쌀쌀한 날씨로, 따뜻하게 옷을 입으세요.",              // 0°C초과 10°C미만
        "추위가 심한 날씨로, 외출 시 따뜻한 옷을 꼭 입으세요."    // 0°C이하
    ]
    
    private let rain = [
        "비가 오지 않습니다.",            // == 0mm
        "비가 옵니다. 우산을 챙기세요."     // 0mm 초과
    ]
    
    private let visibility = [
        "맑은 날씨로, 먼 경치를 감상할 수 있습니다.",            // 8Km초과
        "약간의 안개가 있지만, 운전에 지장이 없는 날씨입니다.",     // 5Km초과 8Km미만
        "안개가 짙어지니 운전 시 주의하세요.",                  // 1Km초과 3Km미만
        "매우 안개가 짙어서 외출 시 위험할 수 있으니 주의하세요."    // 1Km이하
    ]
    
    private let humidity = [
        "습하고 더운 날씨로, 불쾌할 수 있으니 시원한 곳을 찾아 쉬세요.",   // 60%초과
        "적절한 습도로, 편안한 하루를 보낼 수 있습니다.",              // 30%초과 60%미만
        "건조한 날씨입니다. 피부 관리에 주의하세요."                   // 30%이하
    ]
    
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
