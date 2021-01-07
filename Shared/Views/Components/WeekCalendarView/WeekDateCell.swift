//
//  WeekDateCell.swift
//  Grow iOS
//
//  Created by Ryan Thally on 1/7/21.
//  Copyright © 2021 Ryan Thally. All rights reserved.
//

import UIKit

class WeekDateCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectionImage: UIImageView = {
        let imageView = UIImageView()
        
        let circleImageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let circleImage = UIImage(systemName: "circle.fill", withConfiguration: circleImageConfiguration)
        imageView.image = circleImage
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(selectionImage)
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            selectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        hideSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        hideSelection()
    }
    
    func showSelection() {
        UIView.animate(withDuration: 0.2, animations: {
            self.selectionImage.layer.opacity = 1.0
            self.selectionImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        })
    }
    
    func hideSelection() {
        self.selectionImage.layer.opacity = 0.0
        self.selectionImage.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
}

