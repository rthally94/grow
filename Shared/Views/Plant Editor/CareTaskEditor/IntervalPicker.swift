//
//  IntervalPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/16/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct IntervalPicker<Header: View>: View {
    @Environment(\.presentationMode) var presentationMode
    
    var header: Header
    @Binding var selection: CareInterval
    
    // MARK: Selection Functions
    
    private var unitChoice: CareInterval.Unit {
        return selection.unit
    }
    
    private func updateUnitSelection(unit: CareInterval.Unit) {
        selection.unit = unit
        
        switch unit {
        case .weekly: updateWeekdaySelection(daysOfWeek: Set<Int>(0..<7))
        case .monthly: updateDayOfMonth(date: Date())
            
        default:
            selection.interval = []
        }
    }
    
    private func weekdayChoicesBinding() -> Binding<Set<Int>> {
        return Binding<Set<Int>>(get: {self.weekdaySelection}, set: updateWeekdaySelection)
    }
    
    private var weekdaySelection: Set<Int> {
        return selection.interval
    }
    
    private func updateWeekdaySelection(daysOfWeek: Set<Int>) {
        if selection.unit == .weekly {
            selection.interval = daysOfWeek
        }
    }
    
    private func dayOfMonthBinding() -> Binding<Date> {
        return Binding<Date>(get: {self.dateForSelectedDayOfMonth}, set: updateDayOfMonth)
    }
    
    private var dateForSelectedDayOfMonth: Date {
        return Calendar.current.date(bySetting: .day, value: selection.interval.first ?? 1, of: Date()) ?? Date()
    }
    
    private func updateDayOfMonth(date: Date) {
        if selection.unit == .monthly {
            selection.interval = [Calendar.current.component(.day, from: date)]
        }
    }
    
    // MARK: Initializer
    init(header: Header, selection: Binding<CareInterval>) {
        self.header = header
        self._selection = selection
    }
    
    // MARK: Body
    var body: some View {
        Group {
            Section(header: header) {
                ForEach(CareInterval.Unit.allCases, id: \.self) { unit in
                    HStack {
                        Text(unit.description.capitalized)
                        Spacer()
                        if self.unitChoice == unit {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                                .transition(.identity)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            self.updateUnitSelection(unit: unit)
                        }
                    }
                }
            }
            
            if unitChoice == .weekly {
                Section {
                    WeekPicker(selection: weekdayChoicesBinding())
                        .frame(maxWidth: .infinity)
                }
            }
            
            if unitChoice == .monthly {
                Section(footer: Text(monthlyFooter)) {
                    DatePicker("Starting", selection: dayOfMonthBinding(), in: startDate...endDate, displayedComponents: .date)
                }
            }
        }
    }
    
    // MARK: Constants
    private let startDate = Date()
    private let endDate = Calendar.current.date(byAdding: .year, value: 10, to: Date()) ?? Date()
    
    // MARK: Computed Properties
    private var monthlyFooter: String {
        let dayOfMonth = Formatters.ordinalNumberFormatter.string(for: selection.interval)
        return "This task will repeat" + (dayOfMonth != nil ? "on the \(dayOfMonth!) on every month" : "every month")
    }
}

extension IntervalPicker where Header == EmptyView {
    init(selection: Binding<CareInterval>) {
        self.init(header: EmptyView(), selection: selection)
    }
}

struct IntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        return
            StatefulPreviewWrapper(CareInterval()) { state in
                List {
                    Text( state.wrappedValue.description )
                    IntervalPicker(selection: state)
                }.listStyle(GroupedListStyle())
        }
    }
}
