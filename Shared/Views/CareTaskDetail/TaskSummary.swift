//
//  TaskSummary.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/21/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct TaskSummary: View {
    @ObservedObject var task: CareTask
    
    var body: some View {
        Section(header: summaryHeader.textCase(nil)) {
            summaryView
                .padding(.vertical, 4)
        }
    }
    
    var completedTaskDays: Set<Int> {
        func logIsInMonth(_ log: CareTaskLog, in date: DateComponents) -> Bool {
            let components = Calendar.current.dateComponents([.year, .month], from: log.date)
            return components.year == date.year && components.month == date.month
        }
        
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        
        let logs = task.logs.filter({ logIsInMonth($0, in: components)})
        
        return Set<Int>( logs.map { Calendar.current.component(.day, from: $0.date) })
    }
    
    var summaryString: String {
        switch task.intervalUnit {
        default:
            return "Performed \(task.logs.count) times this month."
        }
    }
    
    var summaryHeader: some View {
        switch task.intervalUnit {
        default:
            return Text(summaryString)
        }
    }
    
    var currentMonth: String {
        let month = Calendar.current.component(.month, from: Date())
        return Calendar.current.standaloneMonthSymbols[month-1]
    }
    
    var summaryView: some View {
        Group {
            switch task.intervalUnit {
            default:
                MonthCalendarView(date: Date(), selection: .constant(completedTaskDays), header: Text(currentMonth).font(.headline)) { day in
                    Group {
                        switch (completedTaskDays.contains(day), task.intervalValues.contains(day)) {
                        case (true, true):
                            Image(systemName: "checkmark.square")
                                .foregroundColor(.accentColor)
                        case (true, false):
                            Image(systemName: "checkmark.square")
                                .foregroundColor(.gray)
                        case(false, true):
                            Text("\(day)")
                                .font(.body)
                                .foregroundColor(.accentColor)
                        default:
                            Text("\(day)")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                    .font(.title)
                }
                .padding(.top, 4)
            }
        }
    }
}
struct TaskSummary_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        
        let request = CareTask.allTasksFetchRequest()
        request.fetchLimit = 1
        
        let task = try? viewContext.fetch(request).first
        
        return TaskSummary(task: task!)
    }
}
