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
    
    @Binding var intervalUnit: IntervalChoices {
        willSet {
            switch newValue {
            // When going, reapply state
            case .weekly:
                intervalValues = [ Calendar.current.component(.weekday, from: Date()) ]
            case.monthly:
                intervalValues = [ Calendar.current.component(.day, from: Date()) ]
                
            default:
                return
            }
        }
    }
    
    @Binding var intervalValues: Set<PickerChoice>
    
    var eventOccurance: String {
        switch intervalUnit {
        case .never:
            return "Task does not repeat."
        case .weekly:
            let weekdays = Array(intervalValues).sorted()
            let weekdayLabels = weekdays.map { Calendar.current.shortWeekdaySymbols[$0-1]}
            return "Task repeats \(intervalUnit.description) on \( ListFormatter.localizedString(byJoining: weekdayLabels) ).."
        case .monthly:
            let days = Array(intervalValues).sorted()
            let dayOrdinals = days.map { NumberFormatter.localizedString(from: $0 as NSNumber, number: .ordinal) }
            return "Task repeats \(intervalUnit.description) on the \( ListFormatter.localizedString(byJoining: dayOrdinals) )."
            
        default:
            return "Task repeats \(intervalUnit.description)."
        }
    }
    
    // MARK: Body
    var body: some View {
        List {
            // Interval Choices
            Section(footer: Text(eventOccurance)) {
                ForEach(IntervalChoices.allCases, id: \.self) { intervalChoice in
                    Button(action: { onIntervalSelection(interval: intervalChoice)}) {
                        HStack {
                            Text(intervalChoice.description.capitalized)
                            Spacer()
                            
                            if intervalChoice == intervalUnit {
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
                switch intervalUnit {
                case .weekly:
                    WeekPicker(selection: $intervalValues)
                    
                case .monthly:
                    MonthPicker(selection: $intervalValues)
                    
                default:
                    EmptyView()
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    private func onIntervalSelection(interval: IntervalChoices) {
        withAnimation {
            intervalUnit = interval
        }
    }
}

struct IntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper( CareTask.IntervalUnit.never ) { unitState in
            StatefulPreviewWrapper( Set<Int>(arrayLiteral: 1) ) { valueState in
                IntervalPicker(intervalUnit: unitState, intervalValues: valueState)
            }
        }
    }
}
