//
//  AllLogs.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/21/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct AllTaskLogs: View {
    @FetchRequest var logs: FetchedResults<CareTaskLog>
    
    init(task: CareTask) {
        _logs = FetchRequest(fetchRequest: CareTaskLog.fetchLogs(for: task))
    }
    
    var body: some View {
        List(logs, id: \.self) { log in
            Text(log.date, formatter: Formatters.dateFormatter)
        }
        .navigationTitle("All Logs")
    }
}

struct AllLogs_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        
        let request = CareTask.allTasksFetchRequest()
        request.fetchLimit = 1
        
        let task = try? viewContext.fetch(request).first
        
        return AllTaskLogs(task: task!)
    }
}
