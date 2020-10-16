//
//  CalendarView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/13/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct MonthCalendarView<Header: View, Item: View>: View {
    @State var date: Date
    @Binding var selection: Set<Int>
    
    var header: Header
    var content: (Int) -> Item
    
    var calendarRange: Range<Int>? {
        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: date)
        return (daysInMonth?.lowerBound ?? 1)-firstWeekOffset..<(daysInMonth?.upperBound ?? 32)
    }
    
    var firstWeekOffset: Int {
        let today = Calendar.current.startOfDay(for: date)
        if let startOfMonth = Calendar.current.nextDate(after: today, matching: .init(day: 1), matchingPolicy: .previousTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .backward) {
            return Calendar.current.component(.weekday, from: startOfMonth) - 1
        }
        
        return 0
    }
    
    private func dayIsToday(day: Int) -> Bool {
        let year_month = Calendar.current.dateComponents([.year, .month], from: date)
        let dateComponentsToCheck = DateComponents(year: year_month.year, month: year_month.month, day: day)
        if let dateToCheck = Calendar.current.date(from: dateComponentsToCheck) {
            return Calendar.current.isDateInToday(dateToCheck)
        } else {
            return false
        }
    }
    
    init(date: Date, selection: Binding<Set<Int>>, header: Header, @ViewBuilder content: @escaping (Int) -> Item) {
        self._date = State(initialValue: date)
        self._selection = selection
        self.header = header
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(0..<7) { index in
                    Text(Formatters.veryShortDayOfWeek(for: index) ?? "")
                        .font(.caption)
                        .opacity(0.8)
                }
            }
            
            if let days = calendarRange {
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 44)), count: 7), spacing: 10.0, content: {
                    ForEach(days) { day in
                        if day < 1 {
                            Spacer()
                        } else {
                            Button(action: {toggleSelection(for: day)}) {
                                VStack(spacing: 3) {
                                    content(day)
                                        .transition(.asymmetric(insertion: .scale, removal: .identity))
                                    
                                    if dayIsToday(day: day) {
                                        Circle().frame(width: 5, height: 5, alignment: .top).foregroundColor(.gray)
                                    } else {
                                        Circle().frame(width: 5, height: 5, alignment: .top).hidden()
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                })
            }
        }
    }
    
    private func toggleSelection(for day: Int) {
        withAnimation {
            if selection.contains(day) {
                selection.remove(day)
            } else {
                selection.insert(day)
            }
        }
    }
}

extension MonthCalendarView where Header == EmptyView {
    init(date: Date, selection: Binding<Set<Int>>, @ViewBuilder content: @escaping (Int) -> Item) {
        self.init(date: date, selection: selection, header: EmptyView(), content: content)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()
        
        var header: String {
            let month = Calendar.current.component(.month, from: date)
            let year = Calendar.current.component(.year, from: date)
            
            return Calendar.current.monthSymbols[month-1] + " \(year)"
        }
        
        return StatefulPreviewWrapper(Set<Int>()) { state in
            MonthCalendarView(date: date, selection: state, header: Text(header)) { day in
                if state.wrappedValue.contains(day) {
                    Text("\(day)")
                        .foregroundColor(.blue)
                } else {
                    Text("\(day)")
                }
            }
        }
    }
}
