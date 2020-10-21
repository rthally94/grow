//
//  WeekCalendarView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/14/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct WeekCalendarView<Header: View, Item: View>: View {
    @State var date: Date
    @Binding var selection: Set<Int>
    
    var header: Header
    var content: (Int, Int) -> Item
    
    var daysInWeek: Range<Int> {
        return Calendar.current.range(of: .day, in: .weekOfMonth, for: date) ?? 0..<7
    }
    
    var startOfWeek: Int {
        daysInWeek.first ?? 0
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
    
    init(date: Date, selection: Binding<Set<Int>>, header: Header, @ViewBuilder content: @escaping (Int, Int) -> Item) {
        self._date = State(initialValue: date)
        self._selection = selection
        self.header = header
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(daysInWeek) { day in
                    Text(Formatters.veryShortDayOfWeek(for: day-startOfWeek) ?? "")
                        .font(.caption)
                        .opacity(0.8)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 44)), count: 7), spacing: 10.0) {
                ForEach(daysInWeek) { day in
                    Button(action: { toggleSelection(for: day) }, label: {
                        VStack {
                            content(day-startOfWeek+1, day)
                                .transition(.asymmetric(insertion: .scale, removal: .identity))
                            
                            if dayIsToday(day: day) {
                                Circle().frame(width: 5, height: 5, alignment: .top).foregroundColor(.gray)
                            } else {
                                Circle().frame(width: 5, height: 5, alignment: .top).hidden()
                            }
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                }
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

extension WeekCalendarView where Header == EmptyView {
    init(date: Date, selection: Binding<Set<Int>>, @ViewBuilder content: @escaping (Int, Int) -> Item) {
        self.init(date: date, selection: selection, header: EmptyView(), content: content)
    }
}

struct WeekCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()
        
        return StatefulPreviewWrapper(Set<Int>()) { state in
            WeekCalendarView(date: date, selection: state) { weekday, day in
                if state.wrappedValue.contains(weekday) {
                    Text("\(day)")
                        .foregroundColor(.blue)
                } else {
                    Text("\(day)")
                }
            }
        }
    }
}
