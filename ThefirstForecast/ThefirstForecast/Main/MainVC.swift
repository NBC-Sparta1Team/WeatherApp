//
//  MainVC.swift
//  ThefirstForecast
//  Created by 원동진 on 2/5/24.
//

import UIKit
import Foundation

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        // "날씨" 라벨 추가
        let weatherLabel = UILabel()
        weatherLabel.text = "날씨"
        weatherLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(weatherLabel)
        
        // 검색창 추가
        let searchTextField = UITextField()
        searchTextField.placeholder = "도시 또는 공항 검색"
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "도시 또는 공항 검색", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchTextField)
        
        //테이블 뷰 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
        
        // 섭화씨 전환 버튼 추가
        let settingButton = UIButton(type: .system)
        settingButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingButton.tintColor = .black
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        self.view.addSubview(settingButton)
        
        // UI위치 설정
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -60),
            weatherLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            searchTextField.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            settingButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -60),
            settingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
        ])
    }
    
    // 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // 셀 디자인
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 10
        return cell
    }
    
    // 셀 세로 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // 셀 간격
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    @objc func settingButtonTapped() {
        print("섭씨 화씨 전환")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

