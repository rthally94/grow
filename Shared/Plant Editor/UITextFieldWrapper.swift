//
//  UITextFieldWrapper.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct UITextFieldWrapper: UIViewRepresentable {
    typealias UIViewType = UITextField
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        
        textField.placeholder = placeholder
        textField.text = text
        
        textField.autocapitalizationType = .words
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(context.coordinator.textFieldDidChange(_:)), for: .editingChanged)
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        
        if isFirstResponder {
            uiView.becomeFirstResponder()
        }
    }
    
    var placeholder: String
    @Binding var text: String
    @Binding var isFirstResponder: Bool
    
    init(_ placeHolder: String, text: Binding<String>, isFirstResponder: Binding<Bool> = State(initialValue: false).projectedValue) {
        self.placeholder = placeHolder
        self._text = text
        self._isFirstResponder = isFirstResponder
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
    
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(_ text: Binding<String>) {
            self._text = text
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true
        }
    }
    
}

struct UITextFieldWrapper_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper("") { state in
            VStack {
                UITextFieldWrapper("Text", text: state)
                Text(state.wrappedValue)
            }
        }
    }
}
