//
//  CareTaskCardView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/12/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct CareTaskCardView: View {
    @EnvironmentObject var growModel: GrowModel
    @ObservedObject var task: CareTask
    
    @State var intervalSheetIsPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            typeHeader
                .foregroundColor(Color(task.type.color))
            
            taskIntervalInfo
            Divider()
            HStack {
                lastTaskDate
                Spacer()
                nextTaskDate
                Spacer()
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.systemGroupedBackground))
    }
    
    var typeHeader: some View {
        HStack {
            Image(systemName: "drop.fill")
            Text("Watering")
            Spacer()
            NavigationLink(
                destination: CareTaskDetail(task: task),
                label: {
                    Text("More")
                    Image(systemName: "chevron.right")
                })
                .foregroundColor(.gray)
//            Menu {
//                Button(action: addLog, label: { Label("Add Log", systemImage: "note.text.badge.plus") })
//                Button(action: showIntervalPicker, label: { Label("Change Interval", systemImage: "calendar.badge.clock") })
//            }
//            label: {
//
//            }
        }
    }
    
    var taskIntervalInfo: some View {
        Text(task.intervalDescription)
            .font(.headline)
            .foregroundColor(Color(task.type.color))
    }
    
    var lastTaskDate: some View {
        VStack(alignment: .leading) {
            Text("Last").font(.subheadline).opacity(0.8)
            if let latestLog = task.latestLog {
                Text(latestLog.date, formatter: Formatters.relativeDateFormatter)
            } else {
                Text("Not completed")
            }
        }
    }
    
    var nextTaskDate: some View {
        VStack(alignment: .leading) {
            Text("Next").font(.subheadline).opacity(0.8)
            Text(task.calculateNextCareDate(for: Date()) ?? Date(), formatter: Formatters.relativeDateFormatter)
        }
    }
    
    private func addLog() {
        let date = Date()
        growModel.addLog(date: date, to: task)
    }
    
    private func showIntervalPicker() {
        growModel.sheetToPresent = .configureTaskInterval(task)
    }
}


struct CareTaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        
        let request: NSFetchRequest<CareTaskType> = CareTaskType.allBuiltInTypesRequest()
        request.fetchLimit = 1
        
        let type = try? viewContext.fetch(request).first
        
        let neverTask = CareTask(context: viewContext)
        neverTask.type = type!
        neverTask.intervalUnit = .never
        
        let dailyTask = CareTask(context: viewContext)
        dailyTask.type = type!
        dailyTask.intervalUnit = .daily
        
        let weeklyTask = CareTask(context: viewContext)
        weeklyTask.type = type!
        weeklyTask.interval = (.weekly, [1, 3, 5])
        
        let monthlyTask = CareTask(context: viewContext)
        monthlyTask.type = type!
        monthlyTask.interval = (.monthly, [13])
        
        return Group {
            CareTaskCardView(task: neverTask)
                .previewDisplayName("Repeats Never")
            
            CareTaskCardView(task: dailyTask)
                .previewDisplayName("Repeats Daily")
            
            CareTaskCardView(task: weeklyTask)
                .previewDisplayName("Repeats Weekly")
            
            CareTaskCardView(task: monthlyTask)
                .previewDisplayName("Repeats Monthly")
        }
        .padding()
        .environment(\.managedObjectContext, viewContext)
        .previewLayout(.sizeThatFits)
        
    }
}
