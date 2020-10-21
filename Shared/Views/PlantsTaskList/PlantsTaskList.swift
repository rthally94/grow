//
//  PlantsTaskList.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/28/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantsTaskList: View {
    @FetchRequest(fetchRequest: CareTask.allTasksFetchRequest()) var allTasks: FetchedResults<CareTask>
    
    var careTasksNeedingCareOnSelectedDay: [CareTask] {
        allTasks.filter { task in
            guard let date = task.calculateNextCareDate(for: dateForSelectedDay()) else { return false }
            return Calendar.current.isDate(date, inSameDayAs: dateForSelectedDay())
        }
    }
    
    @State var startingDate: Date = {
        let startOfWeek = Calendar.current.nextDate(after: Date(), matching: .init(weekday: 1), matchingPolicy: .nextTime, direction: .backward) ?? Date()
        return Calendar.current.startOfDay(for: startOfWeek)
    }()
    
    @State var selectedDay: Int = Calendar.current.component(.day, from: Date())
    
    var selectedDayBinding: Binding<Set<Int>> {
        Binding<Set<Int>>(
            get: { [self.selectedDay] },
            set: { self.selectedDay = $0.filter { $0 != selectedDay }.first ?? 1 }
        )
    }
    
    func dateForSelectedDay() -> Date {
        Calendar.current.date(bySetting: .day, value: selectedDay, of: startingDate) ?? Date()
    }
    
    var navigationBarTitle: String {
        let date = dateForSelectedDay()
        return Formatters.relativeDateFormatter.string(for: date)
    }
    
    var sections: [CareTaskType: [CareTask] ] {
        return Dictionary<CareTaskType, [CareTask]>(grouping: careTasksNeedingCareOnSelectedDay, by: { $0.type } )
    }
    
    var body: some View {
        ScrollView {
            VStack {
                WeekCalendarView(date: startingDate, selection: selectedDayBinding) { (index, day) in
                    if selectedDay == day {
                        Text("\(day)")
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 4).strokeBorder(lineWidth: 2, antialiased: true))
                            .foregroundColor(.accentColor)
                            .aspectRatio(1.0, contentMode: .fill)
                    } else {
                        Text("\(day)")
                            .opacity(0.8)
                            .transition(.identity)
                    }
                }
                
                Divider()
                
                LazyVStack {
                    ForEach( [CareTaskType](sections.keys), id: \.self) { key in
                        self.sections[key].map {
                            GrowTaskCard(careTasks: $0 )
                                .padding(.vertical)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle(navigationBarTitle)
    }
}

struct PlantsTaskList_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        
        return NavigationView {
            PlantsTaskList()
        }
        .environment(\.managedObjectContext, viewContext)
    }
}
