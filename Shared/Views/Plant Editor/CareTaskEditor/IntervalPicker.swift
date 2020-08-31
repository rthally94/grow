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
    typealias Interval = CareTaskIntervalMO
    @Environment(\.presentationMode) var presentationMode
    
    var header: Header
    @ObservedObject var selection: Interval
    
    // MARK: Selection Functions
    
    private var unitChoice: Interval.Unit {
        return selection.unit
    }
    
    private func updateUnitSelection(unit: Interval.Unit) {
        selection.unit = unit
        
        switch unit {
        case .weekly: updateWeekdaySelection(daysOfWeek: Set<Int>(0..<7))
        case .monthly: updateDayOfMonth(date: Date())
            
        default:
            selection.values = []
        }
    }
    
    private func weekdayChoicesBinding() -> Binding<Set<Int>> {
        return Binding<Set<Int>>(get: {self.weekdaySelection}, set: updateWeekdaySelection)
    }
    
    private var weekdaySelection: Set<Int> {
        return selection.values
    }
    
    private func updateWeekdaySelection(daysOfWeek: Set<Int>) {
        if selection.unit == .weekly {
            selection.values = daysOfWeek
        }
    }
    
    private func dayOfMonthBinding() -> Binding<Date> {
        return Binding<Date>(get: {self.dateForSelectedDayOfMonth}, set: updateDayOfMonth)
    }
    
    private var dateForSelectedDayOfMonth: Date {
        return Calendar.current.date(bySetting: .day, value: selection.values.first ?? 1, of: Date()) ?? Date()
    }
    
    private func updateDayOfMonth(date: Date) {
        if selection.unit == .monthly {
            selection.values = [Calendar.current.component(.day, from: date)]
        }
    }
    
    // MARK: Initializer
    init(header: Header, selection: CareTaskIntervalMO) {
        self.header = header
        self.selection = selection
    }
    
    // MARK: Body
    var body: some View {
        Group {
            Section(header: header) {
                ForEach(Interval.Unit.allCases, id: \.self) { unit in
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
        let dayOfMonth = Formatters.ordinalNumberFormatter.string(for: selection.values)
        return "This task will repeat" + (dayOfMonth != nil ? "on the \(dayOfMonth!) on every month" : "every month")
    }
}

extension IntervalPicker where Header == EmptyView {
    init(selection: Interval) {
        self.init(header: EmptyView(), selection: selection)
    }
}

struct IntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        let interval = CareTaskIntervalMO(context: .init(concurrencyType: .mainQueueConcurrencyType))
        interval.unit = .weekly
        interval.values = [1, 3, 5]
        return
            List {
                IntervalPicker(selection: interval)
            }
            .listStyle(GroupedListStyle())
    }
}
