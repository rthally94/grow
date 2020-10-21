//
//  MultilineTextEditor.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/21/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct MultilineTextEditor: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text == "" {
                Text(title)
                    .opacity(0.2)
                    .padding(.leading, 6)
            }
            TextEditor(text: $text)
        }
    }
}

struct MultilineTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MultilineTextEditor(title: "Some text", text: .constant(""))
            MultilineTextEditor(title: "Some text", text: .constant("My Stuff"))
        }
    }
}
