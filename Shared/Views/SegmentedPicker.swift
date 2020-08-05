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
    private static let ActiveSegmentColor = Color.GrowGreen2
    private static let BackgroundColor = Color(.systemBackground)
    private static let SelectedTextColor = Color.black
    private static let TextColor = Color(.label).opacity(0.2)
    
    
    private static let TextFont: Font = .system(size: 12)
    
    private static let ActiveSegmentLineWidth: CGFloat = 4
    private static let SegmentCornerRadius: CGFloat = 15
    private static let SegmentXPadding: CGFloat = 8
    private static let SegmentYPadding: CGFloat = 8
    private static let PickerPadding: CGFloat = 4
    
    private static let AnimationDuration: Double = 0.2
    
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
        .padding(SegmentedPicker.PickerPadding)
        .clipShape(RoundedRectangle(cornerRadius: SegmentedPicker.SegmentCornerRadius))
    }
    
    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        CGFloat(selection) * (segmentSize.width + SegmentedPicker.SegmentXPadding)
    }
    
    private var activeSegmentView: AnyView {
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { return EmptyView().eraseToAnyView() }
        
        return Circle()
            .foregroundColor(SegmentedPicker.ActiveSegmentColor)
            .frame(width: segmentSize.width, height: segmentSize.height)
            .offset(x: computeActiveSegmentHorizontalOffset(), y: 0)
            .eraseToAnyView()
    }
    
    private func getSegmentView(for index: Int) -> AnyView {
        guard index < items.count else { return EmptyView().eraseToAnyView() }
        let isSelected = selection == index
        
        return
            Text(items[index])
                .foregroundColor(isSelected ? SegmentedPicker.SelectedTextColor : SegmentedPicker.TextColor)
                .lineLimit(1)
                .padding(.vertical, SegmentedPicker.SegmentYPadding)
                .padding(.horizontal, SegmentedPicker.SegmentXPadding)
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

struct HPicker_Previews: PreviewProvider {
    static var previews: some View {
        return StatefulPreviewWrapper(0) { state in
            VStack {
                Text("\(state.wrappedValue)")
                Divider()
                SegmentedPicker(items: Calendar.current.veryShortStandaloneWeekdaySymbols, selection: state)
            }
        }
    }
}





struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

struct SizeAwareViewModifier: ViewModifier {
    @Binding private var viewSize: CGSize
    
    init(viewSize: Binding<CGSize>) {
        _viewSize = viewSize
    }
    
    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}