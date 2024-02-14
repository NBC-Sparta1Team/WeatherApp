//
//  SearchControllerVC.swift
//  ThefirstForecast
//
//  Created by t2023-m0041 on 2/7/24.
//

import Foundation
import UIKit

class searchControllerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 검색 결과 저장 배열
    var searchResults: [String] = []
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "결과 없음"
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(messageLabel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 초기에는 "결과 없음" 라벨과 아이콘을 표시
        showNoResults()
    }
    
    // 검색어 입력 여부에 따라 UI 업데이트
    func updateUI(with searchText: String) {
        if searchText.isEmpty {
            // 검색어가 비어있는 경우 "결과 없음" 라벨과 아이콘 표시
            showNoResults()
        } else {
            // 검색어가 있는 경우 테이블 뷰에 검색 결과 표시
            messageLabel.text = "\(searchText) : 결과 없음"
            tableView.reloadData()
            tableView.isHidden = false
            messageLabel.isHidden = true
            imageView.isHidden = true
        }
    }
    
    // "결과 없음" 라벨과 아이콘 표시
    func showNoResults() {
        tableView.isHidden = true
        messageLabel.isHidden = false
        imageView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    // MARK: - 테이블뷰 델리게이트
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 검색창에서 해당 검색어를 선택했을 때의 동작 구현
        // 바깥 콜렉션 뷰에 업데이트 등
    }
}

