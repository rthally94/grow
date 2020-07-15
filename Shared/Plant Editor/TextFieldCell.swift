//
//  TextFieldTableViewCell.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/17/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate: class {
    func textFieldDidEndEditing(_ textField: UITextField)
}

class TextFieldCell: UITableViewCell {
    static let reuseIdentifier = "TextFieldCell"
    weak var delegate: TextFieldCellDelegate?
      
    private let textField: UITextField = {
        let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.autocapitalizationType = .words
        field.keyboardType = .alphabet
        return field
    }()
    
    var fieldText: String? {
        get {
            return textField.text
        }
        
        set {
            textField.text = newValue
        }
    }
    
    var fieldPlaceholder: String? {
        get {
            return textField.placeholder
        }
        
        set {
            textField.placeholder = newValue
        }
    }
    
    func textFieldShouldResignFirstResponder() {
        textField.resignFirstResponder()
    }
    
    // MARK: Lifecycle Methods
    
    override func layoutSubviews() {
        configureHiearchy()
        textField.delegate = self
        
        super.layoutSubviews()
    }
    
    private func configureHiearchy() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField)
    }
}
