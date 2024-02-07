//
//  WindView.swift
//  ThefirstForecast
//
//  Created by t2023-m0026 on 2/7/24.
//

import UIKit

class WindView: UIView {
    private let windSpeedScale : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let windLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let windSpeed : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let gustScale : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let gustLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let gustSpeed: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let windDirection : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let borderLine = UIView()
    
    private let compassScale : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "compassScale")
        return image
    }()
    
    private let magneticNeedle : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "magneticNeedle")
        return image
    }()
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(#function)
        borderLine.backgroundColor = .white
        setBackgroundBlur(blurEffect: .regular)
        addSubViewsInWindView()
        autoLayoutWindView()
        setWindViewLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#function, "UIView")
    }
    
    // superview가 없어서 그런지 가장 마지막에 layoutSubviews 이후에 크기가 지정됨

    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func setBackgroundBlur(blurEffect: UIBlurEffect.Style) {
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
    
        
    func addSubViewsInWindView() {
        addSubViews([
            windSpeedScale,
            windLabel,
            windSpeed,
            gustScale,
            gustLabel,
            gustSpeed,
            windDirection,
            borderLine,
            compassScale,
            magneticNeedle
        ])
        print(#function)
    }
    
    func autoLayoutWindView() {
        print("WindView.bounds : \(self.bounds)")

        windSpeedScale.translatesAutoresizingMaskIntoConstraints = false
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeed.translatesAutoresizingMaskIntoConstraints = false
        gustScale.translatesAutoresizingMaskIntoConstraints = false
        gustLabel.translatesAutoresizingMaskIntoConstraints = false
        gustSpeed.translatesAutoresizingMaskIntoConstraints = false
        windDirection.translatesAutoresizingMaskIntoConstraints = false
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        compassScale.translatesAutoresizingMaskIntoConstraints = false
        magneticNeedle.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            borderLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            borderLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            borderLine.heightAnchor.constraint(equalToConstant: 1),
            borderLine.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 4 / 7),
            
            windSpeed.bottomAnchor.constraint(equalTo: borderLine.topAnchor, constant: -10),
            windSpeed.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            windLabel.bottomAnchor.constraint(equalTo: windSpeed.bottomAnchor, constant: -5),
            windLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
            
            windSpeedScale.bottomAnchor.constraint(equalTo: windLabel.topAnchor, constant: -1),
            windSpeedScale.centerXAnchor.constraint(equalTo: windLabel.centerXAnchor),
            
            gustSpeed.topAnchor.constraint(equalTo: borderLine.bottomAnchor, constant: 10),
            gustSpeed.centerXAnchor.constraint(equalTo: windSpeed.centerXAnchor),
            
            gustScale.topAnchor.constraint(equalTo: gustSpeed.topAnchor, constant: 5),
            gustScale.centerXAnchor.constraint(equalTo: windLabel.centerXAnchor),
            
            gustLabel.topAnchor.constraint(equalTo: gustScale.bottomAnchor, constant: 1),
            gustLabel.centerXAnchor.constraint(equalTo: windLabel.centerXAnchor),
            
            windDirection.centerXAnchor.constraint(equalTo: compassScale.centerXAnchor),
            windDirection.centerYAnchor.constraint(equalTo: compassScale.centerYAnchor),
            
            compassScale.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            compassScale.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            compassScale.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 3),
            compassScale.heightAnchor.constraint(equalTo: compassScale.widthAnchor),
            
            magneticNeedle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            magneticNeedle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            magneticNeedle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 3),
            magneticNeedle.heightAnchor.constraint(equalTo: magneticNeedle.widthAnchor),
        ])
        print(#function)
    }
    
    func setWindViewLabel() {
        windSpeedScale.text = "m/s"
        windLabel.text = "바람"
        windSpeed.text = "55"
        gustScale.text = "m/s"
        gustLabel.text = "돌풍"
        gustSpeed.text = "3"
        let degree = 140
        let cgFloat = CGFloat(degree) * .pi / 360
        magneticNeedle.transform = magneticNeedle.transform.rotated(by: cgFloat)
        switch degree {
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
        print(#function)
    }
}
