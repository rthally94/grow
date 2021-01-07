//
//  WeekLabelCell.swift
//  Grow iOS
//
//  Created by Ryan Thally on 1/7/21.
//  Copyright © 2021 Ryan Thally. All rights reserved.
//

import UIKit

class WeekLabelCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)
        
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
