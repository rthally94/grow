//
//  UITextFieldWrapper.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct UITextFieldWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        
        textField.placeholder = placeholder
        textField.text = text
        
        textField.autocapitalizationType = .words
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        
        textField.delegate = context.coordinator
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    typealias UIViewType = UITextField
    
    var placeholder: String
    @Binding var text: String
    
    init(_ placeHolder: String, text: Binding<String>) {
        self.placeholder = placeHolder
        self._text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
    
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(_ text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            print("Did End")
            text = textField.text ?? ""
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