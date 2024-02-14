//
//  WindView.swift
//  ThefirstForecast
//
//  Created by t2023-m0026 on 2/7/24.
//

import UIKit

class WindView: UICollectionViewCell {
    static let reuseIdentifier = "windCollectionViewCell"
    
    private let windIcon : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "wind")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        image.tintColor = UIColor.white.withAlphaComponent(0.5)
        return image
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.text = "바람"
        return label
    }()
    
    private let windSpeedScale : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    private let windLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let windSpeedLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 38, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let gustScale : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    private let gustLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let gustSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 38, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let windDirection : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let north : UILabel = {
        let label = UILabel()
        label.text = "북"
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    private let west : UILabel = {
        let label = UILabel()
        label.text = "서"
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    private let east : UILabel = {
        let label = UILabel()
        label.text = "동"
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    private let south : UILabel = {
        let label = UILabel()
        label.text = "남"
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    private let borderLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return view
    }()
    
    private let compassScale : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "compassScale")
        return image
    }()
    
    private let magneticNeedle : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "magneticNeedleBig")
        return image
    }()
    
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print(#function)
//    }

    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder: ) has not been implemented")
//    }
    
//    func setBlurOfWindView(blurEffect: UIBlurEffect.Style) {
//        let blurEffect = UIBlurEffect(style: blurEffect)
//        let effectView = UIVisualEffectView(effect: blurEffect)
//        effectView.frame = self.bounds
//        print("WindView.bounds in", #function, ": \(self.bounds)")
//        effectView.layer.cornerRadius = 15
//        self.layer.cornerRadius = 15
//        
//        // clipsToBounds가 true일 때, EffectView에 cornerRadius 적용됨.
//        effectView.clipsToBounds = true
//        // blur처리된 뷰를 한 겹 올리는 것
//        self.addSubview(effectView)
//    }
    
        
    func addSubViewsInWindView() {
        self.contentView.addSubViews([
            windIcon,
            titleLabel,
            windSpeedScale,
            windLabel,
            windSpeedLabel,
            gustScale,
            gustLabel,
            gustSpeedLabel,
            windDirection,
            north,
            west,
            south,
            east,
            borderLine,
            compassScale,
            magneticNeedle
        ])
        print(#function)
    }
    
    func autoLayoutWindView() {
        print("WindView.bounds in", #function, ": \(self.bounds)")
        windIcon.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedScale.translatesAutoresizingMaskIntoConstraints = false
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        gustScale.translatesAutoresizingMaskIntoConstraints = false
        gustLabel.translatesAutoresizingMaskIntoConstraints = false
        gustSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windDirection.translatesAutoresizingMaskIntoConstraints = false
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        compassScale.translatesAutoresizingMaskIntoConstraints = false
        magneticNeedle.translatesAutoresizingMaskIntoConstraints = false
        north.translatesAutoresizingMaskIntoConstraints = false
        south.translatesAutoresizingMaskIntoConstraints = false
        west.translatesAutoresizingMaskIntoConstraints = false
        east.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            windIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            windIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            windIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 10),
            windIcon.widthAnchor.constraint(equalTo: windIcon.heightAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: windIcon.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: windIcon.trailingAnchor, constant: 7),
            
            borderLine.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10),
            borderLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            borderLine.heightAnchor.constraint(equalToConstant: 1),
            borderLine.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 5 / 9),
            
            windSpeedLabel.bottomAnchor.constraint(equalTo: borderLine.topAnchor, constant: -10),
            windSpeedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            
            windLabel.bottomAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: -5),
            windLabel.leadingAnchor.constraint(equalTo: windSpeedLabel.trailingAnchor, constant: 10),
            
            windSpeedScale.bottomAnchor.constraint(equalTo: windLabel.topAnchor, constant: -1),
            windSpeedScale.centerXAnchor.constraint(equalTo: windLabel.centerXAnchor),
            
            gustSpeedLabel.topAnchor.constraint(equalTo: borderLine.bottomAnchor, constant: 10),
            gustSpeedLabel.centerXAnchor.constraint(equalTo: windSpeedLabel.centerXAnchor),
            
            gustScale.topAnchor.constraint(equalTo: gustSpeedLabel.topAnchor, constant: 5),
            gustScale.centerXAnchor.constraint(equalTo: windLabel.centerXAnchor),
            
            gustLabel.topAnchor.constraint(equalTo: gustScale.bottomAnchor, constant: 1),
            gustLabel.centerXAnchor.constraint(equalTo: windLabel.centerXAnchor),
            
            windDirection.centerXAnchor.constraint(equalTo: compassScale.centerXAnchor),
            windDirection.centerYAnchor.constraint(equalTo: compassScale.centerYAnchor),
            
            north.centerXAnchor.constraint(equalTo: compassScale.centerXAnchor),
            north.topAnchor.constraint(equalTo: compassScale.topAnchor, constant: 10),
            
            west.leadingAnchor.constraint(equalTo: compassScale.leadingAnchor, constant: 10),
            west.centerYAnchor.constraint(equalTo: compassScale.centerYAnchor),
            
            east.trailingAnchor.constraint(equalTo: compassScale.trailingAnchor, constant: -10),
            east.centerYAnchor.constraint(equalTo: compassScale.centerYAnchor),
            
            south.centerXAnchor.constraint(equalTo: compassScale.centerXAnchor),
            south.bottomAnchor.constraint(equalTo: compassScale.bottomAnchor, constant: -10),
            
            compassScale.centerYAnchor.constraint(equalTo: borderLine.centerYAnchor),
            compassScale.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            compassScale.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 3),
            compassScale.heightAnchor.constraint(equalTo: compassScale.widthAnchor),
            
            magneticNeedle.centerYAnchor.constraint(equalTo: compassScale.centerYAnchor),
            magneticNeedle.centerXAnchor.constraint(equalTo: compassScale.centerXAnchor),
            magneticNeedle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 3),
            magneticNeedle.heightAnchor.constraint(equalTo: magneticNeedle.widthAnchor),
        ])
    }
    
    func setWindViewLabel(windSpeed: String, gustSpeed: String, windDegree: Int) {
        addSubViewsInWindView()
        autoLayoutWindView()
        
        windSpeedScale.text = "m/s"
        windLabel.text = "바람"
        windSpeedLabel.text = windSpeed
        gustScale.text = "m/s"
        gustLabel.text = "돌풍"
        gustSpeedLabel.text = gustSpeed
        let windDegree = windDegree
        print(windDegree)
        let cgFloat = CGFloat(windDegree) * .pi / 180
        magneticNeedle.transform = magneticNeedle.transform.rotated(by: cgFloat)
        switch windDegree {
        case 0 ... 11 :
            windDirection.text = "북"
        case 12 ... 34 :
            windDirection.text = "북북동"
        case 35 ... 56 :
            windDirection.text = "북동"
        case 57 ... 79 :
            windDirection.text = "동북동"
        case 80 ... 101 :
            windDirection.text = "동"
        case 102 ... 124 :
            windDirection.text = "동남동"
        case 125 ... 146 :
            windDirection.text = "남동"
        case 147 ... 169 :
            windDirection.text = "남남동"
        case 170 ... 191 :
            windDirection.text = "남"
        case 192 ... 214 :
            windDirection.text = "남남서"
        case 215 ... 236 :
            windDirection.text = "남서"
        case 237 ... 248 :
            windDirection.text = "서남서"
        case 249 ... 281 :
            windDirection.text = "서"
        case 282 ... 304 :
            windDirection.text = "서북서"
        case 305 ... 326 :
            windDirection.text = "북서"
        case 327 ... 349 :
            windDirection.text = "북북서"
        case 350 ... 359 :
            windDirection.text = "북"
        default:
            windDirection.text = "알 수 없음"
        }
    }
}
