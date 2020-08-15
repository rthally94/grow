//
//  CareTaskEditor.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct CareTaskEditor: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CareTaskType.AllTaskTypesFetchRequest) var taskTypes: FetchedResults<CareTaskType>
    
    @Binding var selectedTaskID: UUID?
    @ObservedObject var task: CareTask
    
//    var onSave: () -> Void
    
    var body: some View {
        List {
            Section(header: Text("What").font(.headline)) {
                CareTaskTypePicker(selection: $task.type)
            }
            
            IntervalPicker(header: Text("Repeats").font(.headline), selection: task.interval)

            Section {
                UITextFieldWrapper("Notes", text: $task.notes)
            }
        }
        .listStyle(GroupedListStyle())
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: Button(action: goBack, label: {
//            HStack {
//                Image(systemName: "chevron.left")
//                Text("Details")
//            }
//        }))
    }
    
//    func goBack() {
//        onSave()
//    }
}

struct CareTaskEditor_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let task = CareTask(context: context)
        
        return CareTaskEditor(selectedTaskID: .constant(task.id), task: task)
    }
}
