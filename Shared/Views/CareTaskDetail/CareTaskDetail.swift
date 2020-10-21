//
//  CareTaskDetail.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/31/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct CareTaskDetail: View {
    @ObservedObject var task: CareTask
    private var taskNoteBinding: Binding<String> {
        return Binding<String>(
            get: {
                task.note
            },
            set: {
                task.note = $0.trimmingCharacters(in: .newlines)
            }
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Summary").font(Font.headline).textCase(nil)) {
                VStack(alignment: .leading) {
                    taskIntervalInfo
                    Divider()
                    HStack {
                        lastTaskDate
                        Spacer()
                        nextTaskDate
                        Spacer()
                    }
                }
                .padding(.vertical, 4)
            }
            
            TaskSummary(task: task)
            
            Section (header: Text("Care Notes").font(.headline).textCase(nil) ) {
                
                MultilineTextEditor(title: "Add a note", text: taskNoteBinding)
            }
            
            Section(header: logHistoryHeader.textCase(nil)) {
                CareTaskLogsPreview(task: task)
            }
        }
        .navigationTitle(task.type.name)
        .listStyle(InsetGroupedListStyle())
    }
    
    var taskIntervalInfo: some View {
        VStack(alignment: .leading) {
            Text("Interval").font(.subheadline).opacity(0.8)
            Text(task.intervalDescription)
        }
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
    
    var logHistoryHeader: some View {
        HStack {
            Text("History").font(.headline)
            Spacer()
            NavigationLink("View All", destination: AllTaskLogs(task: task))
        }
    }
    
    // MARK: Constants
    private let notesLineLimit = 3
    private let numberOfVisibleLogs = 4
    
}

struct CareTaskLogsPreview: View {
    @FetchRequest var logs: FetchedResults<CareTaskLog>
    
    init(task: CareTask) {
        _logs = FetchRequest(fetchRequest: CareTaskLog.fetchLogs(for: task, limit: 4))
    }
    
    var body: some View {
        ForEach(logs, id: \.self) { log in
            Text(log.date, formatter: Formatters.dateFormatter)
        }
    }
}

struct CareTaskDetail_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        
        let request = CareTask.allTasksFetchRequest()
        request.fetchLimit = 1
        
        let task = try? viewContext.fetch(request).first
        
        return NavigationView {
            CareTaskDetail(task: task!)
        }
    }
}
    
