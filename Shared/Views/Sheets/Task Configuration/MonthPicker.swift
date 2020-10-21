//
//  MonthPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct MonthPicker: View {
    @Binding var selection: Set<Int>
    
    private var symbols: [String] {
        pickerRange.map{ "\($0)" }
    }
    
    private var pickerRange: Range<Int> {
        1..<32
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(pickerRange) { index in
                Button(action: { withAnimation{toggleSelection(index)} }) {
                    pickerContent(item: index, isSelected: selection.contains(index))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func toggleSelection(_ index: Int) {
        if selection.contains(index) {
            if selection.count > 1 {
                selection.remove(index)
            }
        } else {
            selection.insert(index)
        }
    }
    
    private func pickerContent(item: Int, isSelected: Bool) -> some View {
        Group {
            if isSelected {
                Text(self.symbols[item-1])
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .frame(minWidth: .zero, maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10))
            } else {
                Text(self.symbols[item-1])
                    .padding(.vertical, 6)
                    .frame(minWidth: .zero, maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .foregroundColor(.gray)
                    
            }
        }
        .foregroundColor(.accentColor)
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct MonthPicker_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(Set(1...4)) { value in
            VStack {
                MonthPicker(selection: value)
                Text(value.wrappedValue.description)
            }
        }
        .previewDisplayName("Multiple Selection")
        .previewLayout(.sizeThatFits)
        .foregroundColor(.green)
    }
}
