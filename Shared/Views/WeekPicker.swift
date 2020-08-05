//
//  WeekPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct WeekPicker: View {
    var singleSelection: Binding<Int?>?
    var multiSelection: Binding<Set<Int>>?
    let pickerIsMulti: Bool
    
    private let symbols = Calendar.current.veryShortStandaloneWeekdaySymbols
    
    init(selection: Binding<Int?>?) {
        singleSelection = selection
        pickerIsMulti = false
    }
    
    init(selection: Binding<Set<Int>>?) {
        multiSelection = selection
        pickerIsMulti = true
    }
    
    var body: some View {
        getPickerView()
    }
    
    private func getPickerView() -> some View {
        if !pickerIsMulti {
            return GrowPicker(0..<symbols.count, selection: singleSelection, content: pickerContent)
        } else {
            return GrowPicker(0..<symbols.count, selection: multiSelection, content: pickerContent)
        }
    }
    
    private func pickerContent(item: Int, isSelected: Bool) -> some View {
        Text(self.symbols[item])
            .padding()
            .background(Circle().scale(isSelected ? 1 : 0))
    }
}

struct WeekPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatefulPreviewWrapper(0) { value in
                VStack {
                    WeekPicker(selection: value)
                    Text(value.wrappedValue?.description ?? "")
                }
            }
            .previewDisplayName("Single Selection")
            
            StatefulPreviewWrapper(Set(0...6)) { value in
                VStack {
                    WeekPicker(selection: value)
                    Text(value.wrappedValue.description)
                }
            }
            .previewDisplayName("Multiple Selection")
        }
        .previewLayout(.sizeThatFits)
        .foregroundColor(.green)
    }
}
