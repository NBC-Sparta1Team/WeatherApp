//
//  CollectionViewHeader.swift
//  ThefirstForecast
//
//  Created by 원동진 on 2/14/24.
//

import UIKit

class MainCollectionViewHeader: UICollectionReusableView {
    static let identi = "CollectionViewHeaderid"
    private lazy var headerNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(headerNameLabel)
        headerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([headerNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),headerNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),headerNameLabel.topAnchor.constraint(equalTo: self.topAnchor),headerNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setLabel(text : String){
        headerNameLabel.text = text
    }
}
