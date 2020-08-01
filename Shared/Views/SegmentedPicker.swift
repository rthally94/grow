//
//  HPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct SegmentedPicker: View {
    //MARK: Drawing Constants
    private static let ActiveSegmentColor = Color(.tertiarySystemBackground)
    private static let BackgroundColor = Color(.secondarySystemBackground)
    private static let ShadowColor = Color.black.opacity(0.2)
    private static let TextColor = Color(.secondaryLabel)
    private static let SelectedTextColor = Color(.label)
    
    private static let TextFont: Font = .system(size: 12)
    
    private static let SegmentCornerRadius: CGFloat = 15
    private static let ShadowRadius: CGFloat = 4
    private static let SegmentXPadding: CGFloat = 16
    private static let SegmentYPadding: CGFloat = 8
    private static let PickerPadding: CGFloat = 4
    
    @Binding private var selection: Int
    private let items: [String]
    
    init(items: [String], selection: Binding<Int>) {
        self._selection = selection
        self.items = items
    }
    
    
    var body: some View {
        HStack {
            ForEach(0..<items.count) { index in
                self.getSegmentView(for: index)
            }
        }
    }
    
    @ViewBuilder private func getSegmentView(for index: Int) -> some View {
        let isSelected = selection == index
        
        return
        if index < items.count {
            Text(items[index])
                .foregroundColor(isSelected ? SegmentedPicker.SelectedTextColor : SegmentedPicker.TextColor)
                .lineLimit(1)
                .padding(.vertical, SegmentedPicker.SegmentYPadding)
                .padding(.horizontal, SegmentedPicker.SegmentXPadding)
                .frame(minWidth: 0, maxWidth: .infinity)
                .onTapGesture { self.onItemTap(index: index) }
        } else {
            Text("1 ")
            //                EmptyView()
        }
    }
    
    private func onItemTap(index: Int) {
        guard index < items.count else { return }
        self.selection = index
    }
}

struct HPicker_Previews: PreviewProvider {
    static var previews: some View {
        let items = [
            "a",
            "b",
            "c",
            "d"
        ]
        
        return StatefulPreviewWrapper(0) { state in
            VStack {
                Text("\(state.wrappedValue)")
                Divider()
                SegmentedPicker(items: items, selection: state)
            }
        }
    }
}
