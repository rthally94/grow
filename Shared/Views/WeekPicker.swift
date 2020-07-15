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
    var selectionMode: SelectionMode
    
    private let calendar = Calendar.current
    
    init(selection: Binding<Set<Int>>, selectionMode: SelectionMode = .single) {
        self._selection = selection
        self.selectionMode = selectionMode
    }
    
    var body: some View {
        HStack {
            ForEach(calendar.weekdaySymbols.indices) { index in
                self.symbolForWeekday(index)
                    .imageScale(.large)
                    .onTapGesture {
                        withAnimation {
                            self.handleSelection(for: index)
                        }
                }
            }
        }
        
    }
    
    private func handleSelection(for index: Int) {
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
    
    private func symbolForWeekday(_ index: Int) -> Image {
        let dayOfWeek = calendar.veryShortWeekdaySymbols[index].lowercased()
        let isSelected = selection.contains(index)
        return Image(systemName: isSelected ? "\(dayOfWeek).circle.fill" : "\(dayOfWeek).circle")
    }
}

struct WeekPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatefulPreviewWrapper(Set(arrayLiteral: 0)) { value in
                WeekPicker(selection: value)
            }
            .previewDisplayName("Single Selection")
            
            StatefulPreviewWrapper(Set(arrayLiteral: 0)) { value in
                WeekPicker(selection: value, selectionMode: .multiple)
            }
            .previewDisplayName("Multiple Selection")
        }.previewLayout(.sizeThatFits)
    }
}
