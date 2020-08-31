//
//  HPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct
edPicker<Label, SelectionValue, Content>: View where Label: View, SelectionValue: Hashable, Content: View {
    @Binding var selection: SelectionValue
    var label: Label
    var content: () -> Content
    
    var body: some View {
        HStack {
            Group {
                content()
            }
            .padding()
            .background(Color.red)
        }
    }
}

struct HPicker_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(0) { state in
            VStack {
                Text("\(state.wrappedValue)")
                Divider()
                SegmentedPicker(selection: state, label: Text("Picker")) {
                    ForEach(0..<5) { index in
                        Text("\(index)")
                    }
                }
            }
        }
    }
}
