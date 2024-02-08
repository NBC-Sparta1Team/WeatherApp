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
    let weather = ["cloud.sun.fill", "cloud.sun.rain.fill", "cloud.sleet.fill", "sun.max.fill", "sun.rain.fill", "rainbow", "cloud.sun.rain.fill", "cloud.sleet.fill", "sun.max.fill"]
    let temperature = [3, 2, 1, 2, 5, 7, 5, 4, 3]
    
    let sectionIcon = ["thermometer.medium", "drop.fill", "eye.fill", "humidity"]
    let category = ["체감온도", "강수량", "가시거리", "습도"]
    let value = [1, 2, 3, 4]
    let weatherDescription = ["습도로 인해 체감 온도가 실제 온도보다 더 높게 느껴집니다.", "이후 수요일에 2mm의 비가 예상됩니다.", "가시거리가 매우 좋습니다.", "현재 이슬점이 23°입니다."]
    
    
    private let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.contentInsetAdjustmentBehavior = .never    // contentView가 navigationBar를 무시하고 constant 잡을 수 있도록 해줌
        view.refreshControl = UIRefreshControl()
        return view
    }()
    
    private let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
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
        self.view.backgroundColor = .orange
        self.navigationController?.navigationBar.isHidden = true
        
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
        
        scrollView.refreshControl?.addTarget(self, action: #selector(refreshFunction), for: .valueChanged)
        
        addSubviewsInForecaseInfoVC()
        autoLayoutInForecastInfoVC()
        
        currentWeatherView.addSubViewsInCurrentWeatherView()
        currentWeatherView.autoLayoutCurrentWeatherView()
        currentWeatherView.setCurrentWeatherLabels()
        
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
    }
    
    // view가 움직일 때마다 계속 호출되고 있음. 사용하면 안됨.
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        print("###", #function)
//    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        print("###", #function)
        setBlurOfDailyWeatherCollectionView(blurEffect: .regular, on: dailyWeatherCollectionView)
        print("collectionView.frame in", #function, ": \(dailyWeatherCollectionView.frame)")
    }
    
    


}

extension ForecastInfoVC {
    
    @objc func refreshFunction() {
        scrollView.refreshControl?.endRefreshing()
        
    }
    
    private func setBlurOfDailyWeatherCollectionView(blurEffect: UIBlurEffect.Style, on thisView: UIView) {
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
        thisView.addSubview(effectView)
    }
    // ForecaseInfo에 addSubView
    private func addSubviewsInForecaseInfoVC() {
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(currentWeatherView)
        contentView.addSubview(dailyWeatherCollectionView)
        contentView.addSubview(otherInfoCollectionView)
        contentView.addSubview(windView)
        
//        view.addSubview(currentWeatherView)
//        view.addSubview(dailyWeatherCollectionView)
//        view.addSubview(otherInfoCollectionView)
//        view.addSubview(windView)
        
        dailyWeatherCollectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier)
        otherInfoCollectionView.register(OtherInfoCollectionViewCell.self, forCellWithReuseIdentifier: OtherInfoCollectionViewCell.reuseIdentifier)
        print(#function)
    }
    
    // Forecast에 들어갈 view들의 layout 설정
    private func autoLayoutInForecastInfoVC() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        dailyWeatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        otherInfoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        windView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.4),
            
            currentWeatherView.topAnchor.constraint(equalTo: contentView.topAnchor),
            currentWeatherView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            currentWeatherView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1 / 2.5), // ForecastInfoVC의 1/2.5 크기로 지정
            
            dailyWeatherCollectionView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: 0),
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
        let numOfSection = 1
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
            let weather = weather[indexPath.item]
            cell?.setCollectionViewCell(
                time: time,
                icon: UIImage(systemName: weather)?.withRenderingMode(.alwaysOriginal) ?? UIImage(),
                temperature: "\(temperature[indexPath.item])°")
            return cell ?? UICollectionViewCell()
        }
        else {
            let cell = otherInfoCollectionView.dequeueReusableCell(withReuseIdentifier: OtherInfoCollectionViewCell.reuseIdentifier, for: indexPath) as? OtherInfoCollectionViewCell
            let sectionIcon = sectionIcon[indexPath.item]
            let category = category[indexPath.item]
            let value = value[indexPath.item]
            let weatherDescription = weatherDescription[indexPath.item]
            cell?.setOtherInfoCell(
                icon: UIImage(systemName: sectionIcon) ?? UIImage(),
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
