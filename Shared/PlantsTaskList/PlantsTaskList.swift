//
//  PlantsTaskList.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/28/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantsTaskList: View {
    @EnvironmentObject var model: GrowModel
    @State var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack {
                WeekCalendarPicker(selectedDate: $selectedDate) { date in
                    Text("\(Calendar.current.component(.weekday, from: date))")
                }
                
                Divider()
              
                Grow_TaskCard()
                Grow_TaskCard()
                Grow_TaskCard()
                
            }
            .padding()
        }
    .navigationBarTitle("Tasks")
    }
}

struct PlantsTaskList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlantsTaskList()
        }
    }
}

struct WeekCalendarPicker<Content: View>: View {
    @Binding var selectedDate: Date
    var content: (Date) -> Content
    
    let calendar = Calendar.current
    
    var start: Date {
        selectedDate.startOfWeek ?? Date()
    }
    
    func nextDate(offset: Int) -> Date {
        let next = calendar.date(byAdding: .weekday, value: offset, to: start) ?? start
        return next
    }
    
    var selectedWeekdayIndex: Int {
        calendar.component(.weekday, from: selectedDate) - 1
    }
    
    var count: Int {
        calendar.veryShortStandaloneWeekdaySymbols.count
    }
    
    func cellColor(for date: Date) -> Color {
        calendar.isDateInToday(date) ? Color.green : Color.gray
    }
    
    var body: some View {
        HStack {
            ForEach(0..<count) { index in
                if index > 0 {
                    Spacer()
                }
                
                VStack {
                    Group {
                        if self.selectedWeekdayIndex == index {
                            Image(systemName: "\(self.calendar.veryShortStandaloneWeekdaySymbols[index].lowercased()).square.fill")
                                .font(.system(size: 24))
                                .transition(.asymmetric(insertion: .scale, removal: .identity))
                            
                        } else {
                            Text(self.calendar.veryShortStandaloneWeekdaySymbols[index])
                                .font(.system(size: 18))
                                .transition(.identity)
                        }
                    }
                    .foregroundColor(self.cellColor(for: self.nextDate(offset: index)))
                    
                    Spacer()
                    
                    self.content(self.nextDate(offset: index))
                }
                .onTapGesture {
                    withAnimation {
                        self.selectedDate = self.nextDate(offset: index)
                    }
                }
                
            }
        }
    }
}
