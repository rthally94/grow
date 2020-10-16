////
////  GrowPicker.swift
////  Grow iOS
////
////  Created by Ryan Thally on 8/3/20.
////  Copyright © 2020 Ryan Thally. All rights reserved.
////
//
//import SwiftUI
//
//struct GrowPicker<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
//    enum SelectionMode: Int {
//        case single
//        case multiple
//    }
//    
//    private let data: Data
//    private let selectionMode: SelectionMode
//    private var singleSelection: Binding<Data.Element>?
//    private var multiSelection: Binding<Set<Data.Element>>?
//    private let content: (Data.Element, Bool) -> Content
//    
//    private var selectedIndices: [Int] {
//        switch selectionMode {
//        case .single:
//            if let value = singleSelection?.wrappedValue, let index = data.firstIndex(of: value) {
//                let indices = [data.distance(from: data.startIndex, to: index)]
//                print(indices)
//                return indices
//            }
//            
//        case .multiple:
//            if let values = multiSelection?.wrappedValue {
//                return values.compactMap { value in
//                    guard let index = data.firstIndex(of: value) else { return nil }
//                    return data.distance(from: data.startIndex, to: index)
//                }
//            }
//        }
//        
//        return []
//    }
//    
//    init(_ data: Data, selection: Binding<Set<Data.Element>>?, @ViewBuilder content: @escaping (Data.Element, Bool) -> Content) {
//        self.data = data
//        self.selectionMode = .multiple
//        self.multiSelection = selection
//        self.content = content
//    }
//    
//    init(_ data: Data, selection: Binding<Data.Element>?, @ViewBuilder content: @escaping (Data.Element, Bool) -> Content) {
//        self.data = data
//        self.selectionMode = .single
//        self.singleSelection = selection
//        self.content = content
//    }
//    
//    var body: some View {
//        Group {
//            if selectionMode == .single {
//                HStack {
//                    ForEach(0..<data.count, id: \.self) { index in
//                        self.getSegmentView(for: index)
//                    }
//                }
//                .padding(10)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//            }
//            
//            if selectionMode == .multiple {
//                HStack {
//                    ForEach(0..<data.count, id: \.self) { index in
//                        self.getSegmentView(for: index)
//                    }
//                }
//                .padding(10)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//            }
//        }
//    }
//    
//    private func getSegmentView(for index: Int) -> some View {
//        guard index < data.count else { return EmptyView() }
//        let _index = data.index(data.startIndex, offsetBy: index)
//        
//        let isSelected = { () -> Bool in
//            switch self.selectionMode {
//            case .single:
//                return self.singleSelection?.wrappedValue == self.data[_index]
//            case .multiple:
//                return self.multiSelection?.wrappedValue.contains(self.data[_index]) ?? false
//            }
//        }()
//        
//        let isDefault = false
//        
//        return
//            Button(action: {self.onItemTap(index: index)}) {
//                content(data[_index], isSelected)
//                    .font(.)
//                .lineLimit(1)
//            }
//            .buttonStyle(PlainButtonStyle())
//            .foregroundColor(getSegmentColor(isSelected: isSelected, isDefault: isDefault))
//            .frame(minWidth: 0, maxWidth: .infinity)
//    }
//    
//    private func getSegmentColor(isSelected: Bool, isDefault: Bool) -> Color {
//        if isSelected {
//            return style.SelectedTextColor
//        } else if isDefault {
//            return style.ActiveSegmentColor
//        } else {
//            return style.TextColor
//        }
//    }
//    
//    private func onItemTap(index: Int) {
//        guard index < data.count else { return }
//        let _index = data.index(data.startIndex, offsetBy: index)
//        
//        withAnimation(.spring()) {
//            switch selectionMode {
//            case .single:
//                if self.singleSelection?.wrappedValue != nil, self.singleSelection?.wrappedValue != self.data[_index] {
//                    self.singleSelection?.wrappedValue = self.data[_index]
//                }
//            case .multiple:
//                guard self.multiSelection?.wrappedValue != nil else { return }
//                if self.multiSelection!.wrappedValue.contains(data[_index]) {
//                    self.multiSelection!.wrappedValue.remove(data[_index])
//                } else {
//                    self.multiSelection!.wrappedValue.insert(data[_index])
//                }
//            }
//        }
//    }
//}
//
//struct GrowPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        let items = Array(UInt8(ascii: "a")..<UInt8(ascii: "g")).map { String(Character(UnicodeScalar($0))) }
//        
//        return
//            Group {
//                StatefulPreviewWrapper("a") { state in
//                    VStack {
//                        GrowPicker(items, selection: state) { item, isSelected in
//                            Text(item)
//                                .padding()
//                                .background(Circle().stroke().scale(isSelected ? 1 : 0))
//                        }
//                        
//                        Divider()
//                        Text(state.wrappedValue)
//                    }
//                }
//                .previewDisplayName("Single Selection")
//                
//                StatefulPreviewWrapper(Set(arrayLiteral: "a", "b")) { state in
//                    VStack {
//                        GrowPicker(items, selection: state) { item, isSelected in
//                            Text(item)
//                                .padding()
//                                .background(Circle().stroke().scale(isSelected ? 1 : 0))
//                        }
//                        Divider()
//                        Text(state.wrappedValue.description)
//                    }
//                }
//                .previewDisplayName("Multiple Selection")
//            }
//            .previewLayout(.sizeThatFits)
//    }
//}
