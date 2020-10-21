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
            task.nextCareDate(for: Date()) == dateForSelectedDay()
        }
    }
    
    @State var startingDate: Date = {
        let startOfWeek = Calendar.current.nextDate(after: Date(), matching: .init(weekday: 1), matchingPolicy: .nextTime, direction: .backward) ?? Date()
        return Calendar.current.startOfDay(for: startOfWeek)
    }()
        
    @State var selectedDay: Int = Calendar.current.component(.weekday, from: Date())
    
    var selectedDayBinding: Binding<Int> {
        Binding<Int>(
            get: { self.selectedDay - 1 },
            set: {
                self.selectedDay = $0 + 1
        })
    }
    
    func dateForSelectedDay() -> Date {
        Calendar.current.date(bySetting: .weekday, value: selectedDay, of: startingDate) ?? Date()
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
//                WeekPicker(selection: selectedDayBinding)
                
                Divider()
                
                ForEach( [CareTaskType](sections.keys), id: \.self) { key in
                    self.sections[key].map {
                        GrowTaskCard(careTasks: $0 )
                        .padding(.vertical)
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
        NavigationView {
            PlantsTaskList()
        }
    }
}
