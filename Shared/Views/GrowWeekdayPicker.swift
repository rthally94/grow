//
//  GrowPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/3/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

protocol GrowPickerStyle {
    var ActiveSegmentColor: Color { get set }
    var BackgroundColor: Color { get set }
    var SelectedTextColor: Color { get set }
    var TextColor: Color { get set }
    
    var TextFont: Font { get set }
    
    var ActiveSegmentLineWidth: CGFloat { get set }
    var SegmentCornerRadius: CGFloat { get set }
    var SegmentXPadding: CGFloat { get set }
    var SegmentYPadding: CGFloat { get set }
    var PickerPadding: CGFloat { get set }
    
    var AnimationDuration: Double { get set }
}

struct GrowSegmentedPickerStyle: GrowPickerStyle {
    var ActiveSegmentColor = Color.GrowGreen2
    var BackgroundColor = Color(.systemBackground)
    var SelectedTextColor = Color.black
    var TextColor = Color(.label).opacity(0.2)
    
    
    var TextFont: Font = .system(size: 12)
    
    var ActiveSegmentLineWidth: CGFloat = 4
    var SegmentCornerRadius: CGFloat = 15
    var SegmentXPadding: CGFloat = 8
    var SegmentYPadding: CGFloat = 8
    var PickerPadding: CGFloat = 4
    
    var AnimationDuration: Double = 0.2
}

struct GrowWeekdayPicker: View {
    var style: GrowPickerStyle = GrowSegmentedPickerStyle()
    
    @State private var segmentSize: CGSize = .zero
    @Binding private var selection: Int
    
    private let items: [String]
    
    init(items: [String], selection: Binding<Int>) {
        self._selection = selection
        self.items = items
    }
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            activeSegmentView
            
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    self.getSegmentView(for: index)
                }
            }
        }
        .padding(style.PickerPadding)
        .clipShape(RoundedRectangle(cornerRadius: style.SegmentCornerRadius))
    }
    
    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        CGFloat(selection) * (segmentSize.width + style.SegmentXPadding)
    }
    
    private var activeSegmentView: AnyView {
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { return EmptyView().eraseToAnyView() }
        
        return Circle()
            .foregroundColor(style.ActiveSegmentColor)
            .frame(width: segmentSize.width, height: segmentSize.height)
            .offset(x: computeActiveSegmentHorizontalOffset(), y: 0)
            .eraseToAnyView()
    }
    
    private func getSegmentView(for index: Int) -> AnyView {
        guard index < items.count else { return EmptyView().eraseToAnyView() }
        let isSelected = selection == index
        
        return
            Text(items[index])
                .foregroundColor(isSelected ? style.SelectedTextColor : style.TextColor)
                .lineLimit(1)
                .padding(.vertical, style.SegmentYPadding)
                .padding(.horizontal, style.SegmentXPadding)
                .frame(minWidth: 0, maxWidth: .infinity)
                .modifier(SizeAwareViewModifier(viewSize: $segmentSize))
                .onTapGesture { self.onItemTap(index: index) }
                .eraseToAnyView()
    }
    
    
    private func onItemTap(index: Int) {
        guard index < items.count else { return }
        withAnimation {
            self.selection = index
        }
    }
}

extension GrowWeekdayPicker {
    init(Binding<Set<Int>>)
}

struct GrowPicker_Previews: PreviewProvider {
    static var previews: some View {
        let items = Array(UInt8(ascii: "a")..<UInt8(ascii: "g")).map { String(Character(UnicodeScalar($0))) }
            
        return StatefulPreviewWrapper(0) { state in
            GrowWeekdayPicker(items: items, selection: state)
        }
    }
}
