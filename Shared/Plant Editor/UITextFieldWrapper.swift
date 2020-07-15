//
//  UITextField.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct UITextFieldWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    var placeholder: String
    @Binding var text: String
    
    init(_ placeHolder: String, text: Binding<String>) {
        self.placeholder = placeHolder
        self._text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.autocapitalizationType = .words
        
        let vc = UIViewController()
        vc.view.addSubview(textField)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let textField = uiViewController.view.subviews.first as? UITextField {
            textField.text = text
            textField.placeholder = placeholder
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: UITextFieldWrapper
        
        init(_ viewController: UITextFieldWrapper) {
            self.parent = viewController
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            print("Did End")
        }
    }

}
