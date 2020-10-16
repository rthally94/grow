//
//  IntervalPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/16/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct IntervalPicker: View {
    typealias IntervalChoices = CareTask.IntervalUnit
    typealias PickerChoice = Int
    
    @State var intervalSelection: IntervalChoices = .never
    @State var pickerChoice: Set<PickerChoice> = []
    
    // MARK: Body
    var body: some View {
        List {
            // Interval Choices
            Section {
                ForEach(IntervalChoices.allCases, id: \.self) { intervalChoice in
                    Button(action: { onIntervalSelection(interval: intervalChoice)}) {
                        HStack {
                            Text(intervalChoice.description.capitalized)
                            Spacer()
                            
                            if intervalChoice == intervalSelection {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .transition(.identity)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            Section {
                switch intervalSelection {
                case .weekly:
                    WeekPicker(selection: $pickerChoice)
                    
                case .monthly:
                    Group {
                        Text("1")
                        Text("2")
                    }
                    
                default:
                    EmptyView()
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    private func onIntervalSelection(interval: IntervalChoices) {
        withAnimation {
            intervalSelection = interval
        }
    }
}

struct IntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        IntervalPicker()
    }
}
