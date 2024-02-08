//
//  ForecastInfoVC.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit

enum WeatherSection {
    case dailyWeather([Int])
    case dailyForecastInfo([String])
    case wind([String])
}

class ForecastInfoVC: UIViewController {
    
    let time = ["오전 0시", "오전 3시", "오전 6시", "오전 9시", "오전 12시", "오전 15시", "오전 18시", "오전 21시", "오전 24시"]
    let temperature = [3, 2, 1, 2, 5, 7, 5, 4, 3]
    
    let category = ["1체감온도", "2강수량", "3가시거리", "4습도"]
    let value = [1, 2, 3, 4]
    let weatherDescription = ["1습도로 인해 체감 온도가 실제 온도보다 더 높게 느껴집니다.", "2이후 수요일에 2mm의 비가 예상됩니다.", "3가시거리가 매우 좋습니다.", "4현재 이슬점이 23°입니다."]
    
    // 모든 요소 담고있는 stackView
    private let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()
    
    // 위치, 현재온도(main.temp), 기상상태(weather.main), 최고&최저 온도(main.temp_min&max) 보여주는 view
    private let currentWeatherView : CurrentWeatherView = {
        let view = CurrentWeatherView()
        return view
    }()
    
    // 3시간 단위 온도변화를 표현하는 collectionView(시간, 온도, 아이콘)
    private let dailyWeatherCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 8
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()
    
    // 체감온도, 습도, 가시거리, 강수량 표현하는 collectionView 작성예정
    private let otherInfoCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 8
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    // 풍속(wind.speed), 돌풍(wind.gust), 풍향(wind.deg) 담고있는 view
    private let windView : WindView = {
        let view = WindView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        return view
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("#", #function)
        
        let backgroundImage = UIImageView(image: UIImage(named: "backgroundImage"))
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        print("collectionView.frame in", #function, ": \(dailyWeatherCollectionView.frame)")
        
        dailyWeatherCollectionView.delegate = self
        dailyWeatherCollectionView.dataSource = self
        dailyWeatherCollectionView.reloadData()
        
        otherInfoCollectionView.delegate = self
        otherInfoCollectionView.dataSource = self
        otherInfoCollectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("##", #function)
        currentWeatherView.addSubViewsInCurrentWeatherView()
        currentWeatherView.autoLayoutCurrentWeatherView()
        currentWeatherView.setCurrentWeatherLabels()
        print("collectionView.frame in", #function, ": \(dailyWeatherCollectionView.frame)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("###", #function)
        setBackgroundBlur(blurEffect: .regular, on: dailyWeatherCollectionView)
        print("collectionView.frame in", #function, ": \(dailyWeatherCollectionView.frame)")
        addSubviewsInForecaseInfoVC()
        autoLayoutInForecastInfoVC()
    }
    
    


}

extension ForecastInfoVC {
    
    private func setBackgroundBlur(blurEffect: UIBlurEffect.Style, on thisView: UIView) {
        print(#function)
        let blurEffect = UIBlurEffect(style: blurEffect)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = thisView.frame
        print("effectView.frame : \(effectView.frame)")
        effectView.layer.cornerRadius = 15
        thisView.layer.cornerRadius = 15
        
        // clipsToBounds가 true일 때, EffectView에 cornerRadius 적용됨.
        effectView.clipsToBounds = true
        // blur처리된 뷰를 한 겹 올리는 것
        view.addSubview(effectView)
    }
    // ForecaseInfo에 addSubView
    private func addSubviewsInForecaseInfoVC() {
        view.addSubview(stackView)
        view.addSubview(currentWeatherView)
        view.addSubview(dailyWeatherCollectionView)
        
//        stackView.addArrangedSubview(dailyWeatherCollectionView)
        view.addSubview(otherInfoCollectionView)
        view.addSubview(windView)
        
        dailyWeatherCollectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier)
        otherInfoCollectionView.register(OtherInfoCollectionViewCell.self, forCellWithReuseIdentifier: OtherInfoCollectionViewCell.reuseIdentifier)
        print(#function)
    }
    
    // Forecast에 들어갈 view들의 layout 설정
    private func autoLayoutInForecastInfoVC() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        dailyWeatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        otherInfoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        windView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            currentWeatherView.topAnchor.constraint(equalTo: view.topAnchor),
            currentWeatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentWeatherView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 2.5), // ForecastInfoVC의 1/2.5 크기로 지정
            
            dailyWeatherCollectionView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: -200),
            dailyWeatherCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            dailyWeatherCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            dailyWeatherCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1 / 5),
            
            otherInfoCollectionView.topAnchor.constraint(equalTo: dailyWeatherCollectionView.bottomAnchor, constant: 10),
            otherInfoCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            otherInfoCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            otherInfoCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1 / 2.5),
            
            windView.topAnchor.constraint(equalTo: otherInfoCollectionView.bottomAnchor, constant: 10),
            windView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            windView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            windView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1 / 5),
        ])
        print("collectionView.frame after", #function, ": \(dailyWeatherCollectionView.frame)")
        print("windView.frame after", #function, ": \(windView.frame)")
        print(#function)
    }
}

extension ForecastInfoVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numOfSection = 5
        if collectionView == dailyWeatherCollectionView {
            return numOfSection
        } else {
            return 1
        }
                
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dailyWeatherCollectionView {
            return temperature.count
        } else {
            return category.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dailyWeatherCollectionView {
            let cell = dailyWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as? DailyWeatherCollectionViewCell
            let time = time[indexPath.item]
            cell?.setCollectionViewCell(
                time: time,
                icon: UIImage(systemName: "cloud.sun.rain") ?? UIImage(),
                temperature: "\(temperature[indexPath.item])°")
            return cell ?? UICollectionViewCell()
        }
        else {
            let cell = otherInfoCollectionView.dequeueReusableCell(withReuseIdentifier: OtherInfoCollectionViewCell.reuseIdentifier, for: indexPath) as? OtherInfoCollectionViewCell
            let category = category[indexPath.item]
            let value = value[indexPath.item]
            let weatherDescription = weatherDescription[indexPath.item]
            cell?.setOtherInfoCell(
                icon: UIImage(systemName: "cloud.sun.rain") ?? UIImage(),
                title: category,
                value: String(value),
                description: weatherDescription)
            return cell ?? UICollectionViewCell()
        }
    }
    
    
}

extension ForecastInfoVC : UICollectionViewDelegate {
    
}

extension ForecastInfoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dailyWeatherCollectionView {
            let width = collectionView.frame.width / 4.5
            let height = collectionView.frame.height
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.frame.width / 2 - 5
            let height = collectionView.frame.height / 2 - 5
            return CGSize(width: width, height: height)
        }
    }
}

extension UIView {
    func addSubViews(_ views : [UIView]){
        _ = views.map{self.addSubview($0)}
    }
}
