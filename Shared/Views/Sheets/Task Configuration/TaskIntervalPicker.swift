//
//  PlantIntervalPicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct TaskIntervalPicker: View {
    @EnvironmentObject var growModel: GrowModel
    @ObservedObject var task: CareTask
    
    var body: some View {
        IntervalPicker(intervalUnit: $task.intervalUnit, intervalValues: $task.intervalValues)
            .toolbar {
                ToolbarItem {
                    Button(action: saveAndDismiss, label: {
                        Text("Done")
                    })
                }
            }
    }
    
    private func saveAndDismiss() {
        try? growModel.viewContext.save()
        growModel.sheetToPresent = nil
    }
}

struct PlantIntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        let preview = PersistenceController.preview
        
        let request = CareTask.allTasksFetchRequest()
        request.fetchLimit = 1
        
        let task = try? preview.container.viewContext.fetch(request).first
            
        return TaskIntervalPicker(task: task!)
    }
}
