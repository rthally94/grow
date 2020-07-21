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
                }
            }
            
            if unitChoice == .monthly {
                Section {
                    DatePicker("Starting on", selection: $startDayChoice, in: startDate...endDate, displayedComponents: .date)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Inerval Picker", displayMode: .inline)
    }
    
    // MARK: Constants
    private let startDate = Date()
    private let endDate = Calendar.current.date(byAdding: .year, value: 10, to: Date()) ?? Date()
}

struct IntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IntervalPicker { interval in
                print(interval)
            }
        }
    }
}
