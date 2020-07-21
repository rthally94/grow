//
//  IntervalPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/16/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct IntervalPicker<Header: View>: View {
    @Environment(\.presentationMode) var presentationMode
    
    var header: Header
    var onSave: (CareInterval) -> Void
    
    @State private var unitChoice = CareInterval.Unit.daily
    @State private var weekdayChoices = Set(arrayLiteral: 0)
    @State private var startDayChoice = Date()
    
    init(header: Header, onSave: @escaping (CareInterval) -> Void) {
        self.header = header
        self.onSave = onSave
    }
    
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
                            self.unitChoice = unit
                        }
                    }
                }
            }
            
            if unitChoice == .weekly {
                Section {
                    WeekPicker(selection: $weekdayChoices)
                        .frame(maxWidth: .infinity)
                }
            }
            
            if unitChoice == .monthly {
                Section(footer: Text(monthlyFooter)) {
                    DatePicker("Starting", selection: $startDayChoice, in: startDate...endDate, displayedComponents: .date)
                }
            }
        }
    }
    
    // MARK: Constants
    private let startDate = Date()
    private let endDate = Calendar.current.date(byAdding: .year, value: 10, to: Date()) ?? Date()
    
    // MARK: Computed Properties
    private var monthlyFooter: String {
        let component = Calendar.current.component(.day, from: startDayChoice)
        let dayOfMonth = Formatters.ordinalNumberFormatter.string(for: component) ?? "nil"
        return "This task will repeat on the \(dayOfMonth) day of every month."
    }
}

extension IntervalPicker where Header == EmptyView {
    init(onSave: @escaping (CareInterval) -> Void) {
        self.init(header: EmptyView(), onSave: onSave)
    }
}

struct IntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        List {
            IntervalPicker  { interval in
                print(interval)
            }
        }.listStyle(GroupedListStyle())
    }
}
