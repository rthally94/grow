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
    
    var onCommit: ( () -> Void )?
    
    init(_ placeHolder: String, text: Binding<String>, isFirstResponder: Binding<Bool> = State(initialValue: false).projectedValue, onCommit: ( () -> Void )? = nil) {
        self.placeholder = placeHolder
        self._text = text
        self._isFirstResponder = isFirstResponder
        self.onCommit = onCommit
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: UITextFieldWrapper
        
        init(_ parent: UITextFieldWrapper) {
            self.parent = parent
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.onCommit?()
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
