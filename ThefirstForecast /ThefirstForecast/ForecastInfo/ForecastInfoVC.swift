//
//  ForecastInfoVC.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit
protocol AddActionSendDelegate : AnyObject {
    func sendForecastInfo(data : ForecastInfoModel )
}
class ForecastInfoVC: UIViewController {
    // MARK: 각 View에 사용될 변수
    var addActionDelegate : AddActionSendDelegate?
    // 1. CurrentWeatherView에 사용되는 Data
    var forecastInfo : ForecastInfoModel?
    
    // 2. DailyWeatherCollectionViewCell에 Data
    var oneDay3HourDataList : [OneDay3HourDataModel] = []
    
    // 3. OtherInfoCollectionView에 사용되는 변수들
    var fourForecastData : [FourForecastStatusModel] = []
    
    
    // 4. WindView에 사용되는 Data
    var windy : Wind?
    private lazy var buttonView : UIView = {
        let stackView = UIView()
        
        return stackView
    }()
    private lazy var dismissButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        config.image = UIImage(systemName: "arrowshape.down.circle")
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(tapDimissButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    private lazy var plustButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        config.image = UIImage(systemName: "plus")
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(tapPlusButton), for: .touchUpInside)
        button.tintColor = .white
        button.isHidden = true
        return button
    }()
    
    // MARK: ForecastInfoVC에 포함된 Views 선언
    // 배경
    
    let backgroundImage : UIImageView = {
        let background = UIImageView()
        background.image = UIImage(named: "backgroundImage")
        background.contentMode = .scaleAspectFill
        
        return background
    }()
    // 화면을 스크롤하고, Pull to Refresh하는 ScrollView와 모든 요소가 들어간 contentView
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
    
    
    
    // 1.currentWeather : 위치, 현재온도(main.temp), 기상상태(weather.main), 최고&최저 온도(main.temp_min&max)
    private let currentWeatherView : CurrentWeatherView = {
        let view = CurrentWeatherView()
        return view
    }()
    
    // 2.dailyWeather : 3시간 단위 온도변화를 표현(시간, 온도, 아이콘)
    private let dailyWeatherCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 15
        collectionView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    // 3.otherInfo : 체감온도, 습도, 가시거리, 강수량 표현 collectionView
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
    
    // 4.wind : 풍속(wind.speed), 돌풍(wind.gust), 풍향(wind.deg) 담고있는 view
    private let windView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 15
        collectionView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        get3HoursForecastData(coordinate: forecastInfo?.coord ?? Coord(lat: 0.0, lon: 0.0))
        print("#", #function)
        // 배경은 흰색, navigationBar 숨김
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        // 당겨서 새로고침 -> refreshFunction
        scrollView.refreshControl?.addTarget(self, action: #selector(refreshFunction), for: .valueChanged)
        
        addSubviewsInForecaseInfoVC()
        autoLayoutInForecastInfoVC()
        
        setBlurEffectView(blurEffect: .regular, on: dailyWeatherCollectionView)
        setBlurEffectView(blurEffect: .regular, on: windView)
        
        currentWeatherView.addSubViewsInCurrentWeatherView()
        currentWeatherView.autoLayoutCurrentWeatherView()
        if let weatherViewInfo = self.forecastInfo{
            currentWeatherView.setCurrentWeatherLabels(model: weatherViewInfo )
        }
        
//         windView.setWindViewLabel(
//             windSpeed: windy?.speed ?? 0,
//             gustSpeed:windy?.gust ?? 0,
//             windDegree:windy?.deg ?? 0)
        // MARK: # 뷰 바인딩 수정 필요(CoreData)
//        windView.setWindViewLabel(
//            windSpeed: "\(forecastInfo?.wind.speed ?? 0)",
//            gustSpeed:"\(forecastInfo?.wind.gust ?? 0)",
//            windDegree: forecastInfo?.wind.deg ?? 0)
        
        backgroundImage.isUserInteractionEnabled = true
        currentWeatherView.bringSubviewToFront(buttonView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("##", #function)
        print("dailyWeatherCollectionView.frame : \(dailyWeatherCollectionView.frame)")
        print("dailyWeatherCollectionView.bounds : \(dailyWeatherCollectionView.bounds)")
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        print("###", #function)
        print("dailyWeatherCollectionView.frame : \(dailyWeatherCollectionView.frame)")
        print("dailyWeatherCollectionView.bounds : \(dailyWeatherCollectionView.bounds)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("####", #function)
        print("dailyWeatherCollectionView.frame : \(dailyWeatherCollectionView.frame)")
        print("dailyWeatherCollectionView.bounds : \(dailyWeatherCollectionView.bounds)")
    }
    
    // view가 움직일 때마다 계속 호출되고 있음. 사용하면 안됨.
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        print("###", #function)
    //    }
    
    
}

extension ForecastInfoVC {
    @objc func tapDimissButton(){
        dismiss(animated: true)
    }
    @objc func tapPlusButton(){
        CoreDataManager.shared.createMapData(lat: (forecastInfo?.coord.lat)!, lon: (forecastInfo?.coord.lon)!)
        addActionDelegate?.sendForecastInfo(data: forecastInfo!)
        dismiss(animated: true)
    }
    @objc func refreshFunction() {
        scrollView.refreshControl?.endRefreshing()
        // refresh에 수행할 동작
    }
    public func plustButtonShow(){
        plustButton.isHidden = false
    }
    
    private func setBlurEffectView(blurEffect: UIBlurEffect.Style, on thisView: UICollectionView) {
        print(#function)
        let blurEffect = UIBlurEffect(style: blurEffect)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.layer.cornerRadius = 15
        
        // clipsToBounds가 true일 때, superview를 벗어나는 영역을 잘라냄
        thisView.clipsToBounds = true
        
        // blur 처리된 effectView를 backgroundView로 한 겹 올리는 것
        thisView.addSubview(effectView)
        effectView.frame = thisView.bounds
        thisView.backgroundView = effectView
        
        print("thisView.bounds : \(thisView.bounds)")
    }
    
    // ForecaseInfoVC에 addSubView
    private func addSubviewsInForecaseInfoVC() {
        // backgroundImage를 insertSubview
        view.insertSubview(backgroundImage, at: 0)
        
        // scrollView에 scroll될 contentView를 addSubview하고
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // contentView에 모든 요소 addSubview.
        contentView.addSubview(buttonView)
        contentView.addSubview(currentWeatherView)
        contentView.addSubview(dailyWeatherCollectionView)
        contentView.addSubview(otherInfoCollectionView)
        contentView.addSubview(windView)
        buttonView.addSubview(dismissButton)
        buttonView.addSubview(plustButton)
        
        // collectionView delegate, dataSoure 지정, cell 등록
        dailyWeatherCollectionView.delegate = self
        dailyWeatherCollectionView.dataSource = self
        dailyWeatherCollectionView.reloadData()
        
        otherInfoCollectionView.delegate = self
        otherInfoCollectionView.dataSource = self
        otherInfoCollectionView.reloadData()
        
        windView.delegate = self
        windView.dataSource = self
        windView.reloadData()
        
        dailyWeatherCollectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier)
        otherInfoCollectionView.register(OtherInfoCollectionViewCell.self, forCellWithReuseIdentifier: OtherInfoCollectionViewCell.reuseIdentifier)
        windView.register(WindView.self, forCellWithReuseIdentifier: WindView.reuseIdentifier)
    }
    
    // Forecast에 들어갈 view들의 layout 설정
    private func autoLayoutInForecastInfoVC() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        dailyWeatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        otherInfoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        windView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        plustButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.4),
            //MARK: - Button View
            buttonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            dismissButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 5),
            dismissButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 15),
            dismissButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor),
            
            plustButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 15),
            plustButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -15),
            plustButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -5),
            
            currentWeatherView.topAnchor.constraint(equalTo: buttonView.bottomAnchor),
            currentWeatherView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            currentWeatherView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1 / 3), // ForecastInfoVC의 1/2.5 크기로 지정
            
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
    }
}

extension ForecastInfoVC : UICollectionViewDataSource {
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        let numOfSection = 1
    //        if collectionView == dailyWeatherCollectionView {
    //            return numOfSection
    //        } else {
    //            return 1
    //        }
    //
    //    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dailyWeatherCollectionView {
            print("Count cell")
            return oneDay3HourDataList.count
        } else if collectionView == otherInfoCollectionView {
            return fourForecastData.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dailyWeatherCollectionView {
            let cell = dailyWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as? DailyWeatherCollectionViewCell
            
            cell?.setCollectionViewCell(model: oneDay3HourDataList[indexPath.item])
            
            return cell ?? UICollectionViewCell()
        }
        else if collectionView == otherInfoCollectionView {
            let cell = otherInfoCollectionView.dequeueReusableCell(withReuseIdentifier: OtherInfoCollectionViewCell.reuseIdentifier, for: indexPath) as? OtherInfoCollectionViewCell
            cell?.setOtherInfoCell(model: fourForecastData[indexPath.item])
            
            return cell ?? UICollectionViewCell()
        } else {
            // MARK: # 뷰 바인딩 수정 필요(기존)
            let cell = windView.dequeueReusableCell(withReuseIdentifier: WindView.reuseIdentifier, for: indexPath) as? WindView
//            let windSpeed = windSpeed[indexPath.item]
//            let gustSpeed = gustSpeed[indexPath.item]
//            let windDegree = windDegree[indexPath.item]
            cell?.setWindViewLabel(
                windSpeed: "\(forecastInfo?.wind.speed ?? 0)",
                gustSpeed: "\(forecastInfo?.wind.gust ?? 0)",
                windDegree: forecastInfo?.wind.deg ?? 0
            )
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
            print("Fix cell size")
            return CGSize(width: width, height: height)
        } else if collectionView == otherInfoCollectionView {
            let width = collectionView.frame.width / 2 - 5
            let height = collectionView.frame.height / 2 - 5
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.frame.width
            let height = collectionView.frame.height
            print("Fix cell size")
            return CGSize(width: width, height: height)
        }
    }
}


extension ForecastInfoVC{
    func get3HoursForecastData(coordinate : Coord){
        WeeklyForecastAPIManger.shred.getOneDay3HourForecastData(coordinate: Coordinate(lat: coordinate.lat, lon: coordinate.lon)) { oneDay3HourData in
            DispatchQueue.main.async {
                self.oneDay3HourDataList = oneDay3HourData
                self.dailyWeatherCollectionView.reloadData()
                
            }
            
        }
    }
    
}
