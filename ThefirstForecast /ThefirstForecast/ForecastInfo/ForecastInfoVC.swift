//
//  ForecastInfoVC.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/5/24.
//

import UIKit
protocol AddActionSendDelegate : AnyObject { // 추가한 날씨 데이터
    func sendForecastInfo(data : ForecastInfoModel )
}
class ForecastInfoVC: UIViewController {
    // MARK: 각 View에 사용될 변수
    var addActionDelegate : AddActionSendDelegate?
    // 1. CurrentWeatherView에 사용되는 Data
    var forecastInfo : ForecastInfoModel?
    
    // 2. DailyWeatherCollectionViewCell에 Data
    var oneDay3HourDataList : [OneDay3HourDataModel] = []
    // 검색해서 추가한 예보일경우
    var presentView = 0 // 0 : main , 1: WeeklyForecast
    var selectDate = ""
    // 3. OtherInfoCollectionView에 사용되는 변수들
    var fourForecastData : [FourForecastStatusModel] = []
    // 4. WindView에 사용되는 Data
    var windy : Wind?
    
    // MARK: type이 9개가 맞는지 확실치 않음. thunderstorm == 번개가 맞는지 확실하지 않음.
    let descriptionType = ["맑음", "약간의 구름이 낀 하늘", "구름조금", "온흐림", "실 비", "비", "번개", "눈", "안개"]

    let clearSkyImageName = ["clearSky04to10", "clearSky10to16", "clearSky16to22", "clearSky22to04"]
    let fewCloudsImageName = ["fewClouds04to10", "fewClouds10to16", "fewClouds16to22", "fewClouds22to04"]
    let scatteredCloudsImageName = ["scatteredClouds04to10", "scatteredClouds10to16", "scatteredClouds16to22", "scatteredClouds22to04"]
    let brokenCloudsImageName = ["brokenClouds04to10", "brokenClouds10to16", "brokenClouds16to22", "brokenClouds22to04"]
    let showerRainImageName = ["showerRain04to10", "showerRain10to16", "showerRain16to22", "showerRain22to04"]
    let rainImageName = ["rain04to10", "rain10to16", "rain16to22", "rain22to04"]
    let thunderstormImageName = ["thunderstorm04to10", "thunderstorm10to16", "thunderstorm16to22", "thunderstorm22to04"]
    let snowImageName = ["snow04to10", "snow10to16", "snow16to22", "snow22to04"]
    let mistImageName = ["mist04to10", "mist10to16", "mist16to22", "mist22to04"]
    
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
    
    private lazy var backgroundRefreshButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        config.image = UIImage(systemName: "arrow.circlepath")
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(refreshBackgroundFunction), for: .touchUpInside)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        return button
    }()
    
    // MARK: ForecastInfoVC에 포함된 Views 선언
    // 배경
    let backgroundImage : UIImageView = {
        let background = UIImageView()
        background.image = UIImage(named: "mist22to04")
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
        // 배경은 흰색, navigationBar 숨김
        self.view.backgroundColor = .white
        presentSearchClickState()
        // 당겨서 새로고침 -> refreshFunction
        scrollView.refreshControl?.addTarget(self, action: #selector(refreshFunction), for: .valueChanged)
        addSubviewsInForecaseInfoVC()
        autoLayoutInForecastInfoVC()
        setBlurEffect()
        setCurrentWeatherViewData()
        
        backgroundImage.isUserInteractionEnabled = true
        currentWeatherView.bringSubviewToFront(buttonView)
        
        getCurrentWeatherCondition(model: forecastInfo!)
    }
}
//MARK: - Pubic & ButtonAciton
extension ForecastInfoVC {
    @objc func tapDimissButton(){
        dismiss(animated: true)
    }
    @objc func tapPlusButton(){
        CoreDataManager.shared.createMapData(lat: (forecastInfo?.coord.lat)!, lon: (forecastInfo?.coord.lon)!)
        addActionDelegate?.sendForecastInfo(data: forecastInfo!)
        dismiss(animated: true)
    }
    @objc func refreshBackgroundFunction() {
        // 이미지 이름들이 저장된 배열을 imageNames라는 하나의 배열로 저장
            let imageNames = [
                clearSkyImageName,
                fewCloudsImageName,
                scatteredCloudsImageName,
                brokenCloudsImageName,
                rainImageName,
                thunderstormImageName,
                mistImageName
            ].flatMap{ $0 }
            
            // 현재 설정된 배경 이미지 이름을 가져옴
            guard let currentImageName = backgroundImage.image?.accessibilityIdentifier else {
                return
            }
            
            // 현재 설정된 이미지의 인덱스를 찾음
            guard let currentIndex = imageNames.firstIndex(where: { $0.contains(currentImageName) }) else {
                return
            }
            
            // 다음 이미지의 인덱스를 계산
            let nextIndex = (currentIndex + 1) % imageNames.count
            
            // 다음 이미지 이름을 설정
            let nextImageName = imageNames[nextIndex]
            
            // 이미지를 설정
            backgroundImage.image = UIImage(named: nextImageName)
            backgroundImage.image?.accessibilityIdentifier = nextImageName // 이미지의 accessibilityIdentifier를 설정하여 이미지 이름을 추적할 수 있도록 함
    }
    @objc func refreshFunction() {
        scrollView.refreshControl?.endRefreshing()
        // refresh에 수행할 동작
    }
    public func plustButtonShow(){
        plustButton.isHidden = false
    }
   
}
//MARK: - Private
extension ForecastInfoVC {
   
    private func setBlurEffect(){
        setBlurEffectView(blurEffect: .regular, on: dailyWeatherCollectionView)
        setBlurEffectView(blurEffect: .regular, on: windView)
    }
    private func presentSearchClickState(){
        if presentView != 0 { // 날씨 정보 검색후 Search눌렀을 경우에 Present
            getSelect3HoursForecastData(coordinate: forecastInfo?.coord ?? Coord(lat: 0.0, lon: 0.0), date: selectDate)
        }else{
            get3HoursForecastData(coordinate: forecastInfo?.coord ?? Coord(lat: 0.0, lon: 0.0))
        }
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
        buttonView.addSubview(backgroundRefreshButton)
        
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
        backgroundRefreshButton.translatesAutoresizingMaskIntoConstraints = false
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
            
            backgroundRefreshButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            backgroundRefreshButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dailyWeatherCollectionView {
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
            guard let cell = otherInfoCollectionView.dequeueReusableCell(withReuseIdentifier: OtherInfoCollectionViewCell.reuseIdentifier, for: indexPath) as? OtherInfoCollectionViewCell else {return UICollectionViewCell()}
            cell.setOtherInfoCell(model: fourForecastData[indexPath.item])
            return cell
        } else {
            let cell = windView.dequeueReusableCell(withReuseIdentifier: WindView.reuseIdentifier, for: indexPath) as? WindView
            cell?.setWindViewLabel(
                windSpeed: Int(forecastInfo?.wind.speed ?? 0),
                gustSpeed: Int(forecastInfo?.wind.gust ?? 0),
                windDegree: forecastInfo?.wind.deg ?? 0
            )
            return cell ?? UICollectionViewCell()
        }
    }
}

extension ForecastInfoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dailyWeatherCollectionView {
            let width = collectionView.frame.width / 4.5
            let height = collectionView.frame.height
            return CGSize(width: width, height: height)
        } else if collectionView == otherInfoCollectionView {
            let width = collectionView.frame.width / 2 - 5
            let height = collectionView.frame.height / 2 - 5
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.frame.width
            let height = collectionView.frame.height
            return CGSize(width: width, height: height)
        }
    }
}

//MARK: - GetData
extension ForecastInfoVC{
    func get3HoursForecastData(coordinate : Coord){
        WeeklyForecastAPIManger.shred.getOneDay3HourForecastToday(coordinate: Coordinate(lat: coordinate.lat, lon: coordinate.lon)) { oneDay3HourData in
            DispatchQueue.main.async {
                self.oneDay3HourDataList = oneDay3HourData
                self.dailyWeatherCollectionView.reloadData()
            }
        }
    }
    func getSelect3HoursForecastData(coordinate : Coord,date : String){
        WeeklyForecastAPIManger.shred.getSelectDate3HourForecastData(coordinate: Coordinate(lat: coordinate.lat, lon: coordinate.lon), date: date) { selectOneDay3HourData in
            DispatchQueue.main.async {
                self.oneDay3HourDataList = selectOneDay3HourData
                self.dailyWeatherCollectionView.reloadData()
            }
        }
    }
    private func setCurrentWeatherViewData(){
        if let weatherViewInfo = self.forecastInfo{
            currentWeatherView.setCurrentWeatherLabels(model: weatherViewInfo )
        }
    }
    // MARK: 시간 - 날씨에 따라 backgroundImageView.image 수정
    public func getCurrentWeatherCondition(model: ForecastInfoModel) {
        guard let weatherDescription = model.weather.first?.description else {
            return // 날씨 정보가 없으면 종료
        }
        
        let currentTime = Date() // 현재 날짜, 시간 가져오기
        let calender = Calendar.current
        let hour = calender.component(.hour, from: currentTime)
        print(currentTime)
        
        
        var backgroundImageName: String = ""
        
        // 날씨 설명에 따라 이미지를 선택
        switch weatherDescription {
        case descriptionType[0]: // clear sky
            switch hour {
            case 4..<10:
                backgroundImageName = clearSkyImageName[0]
            case 10..<16:
                backgroundImageName = clearSkyImageName[1]
            case 16..<22:
                backgroundImageName = clearSkyImageName[2]
            case 22..<24:
                backgroundImageName = clearSkyImageName[3]
            case 0..<4:
                backgroundImageName = clearSkyImageName[3]
            default:
                backgroundImageName = "backgroundImage" // 기본 이미지
            }
        case descriptionType[1]: // few clouds
            // few clouds에 대한 이미지 선택 코드 추가
            switch hour {
            case 4..<10:
                backgroundImageName = fewCloudsImageName[0]
            case 10..<16:
                backgroundImageName = fewCloudsImageName[1]
            case 16..<22:
                backgroundImageName = fewCloudsImageName[2]
            case 22..<24:
                backgroundImageName = fewCloudsImageName[3]
            case 0..<4:
                backgroundImageName = fewCloudsImageName[3]
            default:
                backgroundImageName = "backgroundImage" // 기본 이미지
            }
        case descriptionType[2]: // scattered clouds
            // scattered clouds에 대한 이미지 선택 코드 추가
            switch hour {
            case 4..<10:
                backgroundImageName = scatteredCloudsImageName[0]
            case 10..<16:
                backgroundImageName = scatteredCloudsImageName[1]
            case 16..<22:
                backgroundImageName = scatteredCloudsImageName[2]
            case 22..<24:
                backgroundImageName = scatteredCloudsImageName[3]
            case 0..<4:
                backgroundImageName = scatteredCloudsImageName[3]
            default:
                backgroundImageName = "backgroundImage" // 기본 이미지
            }
        case descriptionType[3]: // broken clouds
            // broken clouds에 대한 이미지 선택 코드 추가
            switch hour {
            case 4..<10:
                backgroundImageName = brokenCloudsImageName[0]
            case 10..<16:
                backgroundImageName = brokenCloudsImageName[1]
            case 16..<22:
                backgroundImageName = brokenCloudsImageName[2]
            case 22..<24:
                backgroundImageName = brokenCloudsImageName[3]
            case 0..<4:
                backgroundImageName = brokenCloudsImageName[3]
            default:
                backgroundImageName = "backgroundImage" // 기본 이미지
            }
        case descriptionType[4]: // shower rain
            // shower rain에 대한 이미지 선택 코드 추가
            switch hour {
            case 4..<10:
                backgroundImageName = showerRainImageName[0]
            case 10..<16:
                backgroundImageName = showerRainImageName[1]
            case 16..<22:
                backgroundImageName = showerRainImageName[2]
            case 22..<24:
                backgroundImageName = showerRainImageName[3]
            case 0..<4:
                backgroundImageName = showerRainImageName[3]
            default:
                backgroundImageName = "backgroundImage" // 기본 이미지
            }
        case descriptionType[5]: // rain
            // rain에 대한 이미지 선택 코드 추가
            switch hour {
            case 4..<10:
                backgroundImageName = rainImageName[0]
            case 10..<16:
                backgroundImageName = rainImageName[1]
            case 16..<22:
                backgroundImageName = rainImageName[2]
            case 22..<24:
                backgroundImageName = rainImageName[3]
            case 0..<4:
                backgroundImageName = rainImageName[3]
            default:
                backgroundImageName = "backgroundImage" // 기본 이미지
            }
        case descriptionType[6]: // thunderstorm
            // thunderstorm에 대한 이미지 선택 코드 추가
            switch hour {
            case 4..<10:
                backgroundImageName = thunderstormImageName[0]
            case 10..<16:
                backgroundImageName = thunderstormImageName[1]
            case 16..<22:
                backgroundImageName = thunderstormImageName[2]
            case 22..<24:
                backgroundImageName = thunderstormImageName[3]
            case 0..<4:
                backgroundImageName = thunderstormImageName[3]
            default:
                backgroundImageName = "backgroundImage" // 기본 이미지
            }
        case descriptionType[7]: // snow
            // snow에 대한 이미지 선택 코드 추가
            switch hour {
            case 4..<10:
                backgroundImageName = snowImageName[0]
            case 10..<16:
                backgroundImageName = snowImageName[1]
            case 16..<22:
                backgroundImageName = snowImageName[2]
            case 22..<24:
                backgroundImageName = snowImageName[3]
            case 0..<4:
                backgroundImageName = snowImageName[3]
            default:
                backgroundImageName = "backgroundImage" // 기본 이미지
            }
        case descriptionType[8]: // mist
            // mist에 대한 이미지 선택 코드 추가
            switch hour {
            case 4..<10:
                backgroundImageName = mistImageName[0]
            case 10..<16:
                backgroundImageName = mistImageName[1]
            case 16..<22:
                backgroundImageName = mistImageName[2]
            case 22..<24:
                backgroundImageName = mistImageName[3]
            case 0..<4:
                backgroundImageName = mistImageName[3]
            default:
                backgroundImageName = "backgroundImage" // 기본 이미지
            }
        default:
            // 날씨 설명이 매칭되지 않는 경우에 대한 처리
            backgroundImageName = "backgroundImage"
        }
        print(backgroundImageName)
        // 가져온 이미지 이름으로 이미지를 설정
        backgroundImage.image = UIImage(named: backgroundImageName)
    }

    // 현재 시간을 문자열로 반환하는 함수
    private func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())
    }
}
