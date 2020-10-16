//
//  WeekPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct WeekPicker: View {
    @Binding var selection: Set<Int>
    
    private let symbols = Calendar.current.veryShortStandaloneWeekdaySymbols
    var pickerRange: Range<Int> {
        0..<7
    }
    
    var body: some View {
        HStack {
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
            selection.remove(index)
        } else {
            selection.insert(index)
        }
    }
    
    private func pickerContent(item: Int, isSelected: Bool) -> some View {
        Group {
            if isSelected {
                Text(self.symbols[item])
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .frame(minWidth: .zero, maxWidth: .infinity)
                    .background(Circle())
            } else {
                Text(self.symbols[item])
                    .padding(.vertical, 6)
                    .frame(minWidth: .zero, maxWidth: .infinity)
                    .background(Circle().stroke())
            }
        }
    }
}

struct WeekPicker_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(Set(0...3)) { value in
            VStack {
                WeekPicker(selection: value)
                Text(value.wrappedValue.description)
            }
        }
        .previewDisplayName("Multiple Selection")
        .previewLayout(.sizeThatFits)
        .foregroundColor(.green)
    }
}
