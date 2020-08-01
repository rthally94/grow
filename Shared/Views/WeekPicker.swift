//
//  WeekPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct WeekPicker: View {
    enum SelectionMode {
        case single, multiple
    }
    
    @Binding var selection: Set<Int>
    
    var daysOfWeek: [(String, Bool)] {
        return symbols.enumerated().map { (index, value) in
            let isSelected = selection.contains(index)
            
            return ("\(value.lowercased()).circle.fill", isSelected)
        }
    }
    
    var selectionMode: SelectionMode
    private let symbols = Calendar.current.veryShortStandaloneWeekdaySymbols
    
    init(selection: Binding<Set<Int>>, selectionMode: SelectionMode = .single) {
        self._selection = selection
        self.selectionMode = selectionMode
    }
    
    var body: some View {
        HStack {
            ForEach(Array(daysOfWeek.enumerated()), id: \.0) { (index, day) in
                Image(systemName: day.0)
                    .font(.title)
                    .foregroundColor(day.1 ? .accentColor : .gray)
                    .frame(maxWidth: .infinity)
                    .onTapGesture{ self.handleSelection(index: index) }
            }
        }
    }
    
    func handleSelection(index: Int) {
        switch selectionMode {
        case .single:
            selection.removeAll()
            selection.insert(index)
        case .multiple:
            if selection.contains(index) {
                selection.remove(index)
            } else {
                selection.insert(index)
            }
        }
    }
}

struct WeekPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatefulPreviewWrapper(Set(arrayLiteral: 0)) { value in
                VStack {
                    WeekPicker(selection: value)
                    Text(value.wrappedValue.description)
                }
            }
            .previewDisplayName("Single Selection")
            
            StatefulPreviewWrapper(Set(0...6)) { value in
                VStack {
                    WeekPicker(selection: value, selectionMode: .multiple)
                    Text(value.wrappedValue.description)
                }
            }
            .previewDisplayName("Multiple Selection")
        }
        .previewLayout(.sizeThatFits)
        .foregroundColor(.green)
    }
}
