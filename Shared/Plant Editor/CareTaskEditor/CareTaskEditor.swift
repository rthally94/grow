//
//  CareTaskEditor.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

class CareTaskEditorConfig: ObservableObject {
    @Published var selectedTaskId: UUID? = nil
    
    // View Parameters
    @Published var editMode: EditMode = .inactive
    
    // New task parameters
    @Published var name = ""
    @Published var type: CareTaskType
    @Published var interval: CareTaskInterval
    @Published var note = ""
    
    init() {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        type = CareTaskType(context: context)
        interval = CareTaskInterval(context: context)
    }
    
    func present(task: CareTask) {
        selectedTaskId = task.id
        name = task.type?.name ?? name
        type = task.type ?? type
        interval = task.interval
        note = task.notes
    }
}


struct CareTaskEditor: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CareTaskType.AllTaskTypesFetchRequest) var taskTypes: FetchedResults<CareTaskType>
    
    @ObservedObject var editorConfig: CareTaskEditorConfig
    
    var onSave: () -> Void
    
    var body: some View {
        List {
            Section(header: Text("What").font(.headline)) {
                CareTaskTypePicker(selection: $editorConfig.type)
            }
            
            IntervalPicker(header: Text("Repeats").font(.headline), selection: editorConfig.interval)
            
            Section {
                UITextFieldWrapper("Notes", text: $editorConfig.note)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: goBack, label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("Details")
            }
        }))
    }
    
    func goBack() {
        onSave()
        editorConfig.selectedTaskId = nil
    }
}

struct CareTaskEditor_Previews: PreviewProvider {
    static let config = CareTaskEditorConfig()
    
    static var previews: some View {
        CareTaskEditor(editorConfig: CareTaskEditorConfig()) { }
    }
}
