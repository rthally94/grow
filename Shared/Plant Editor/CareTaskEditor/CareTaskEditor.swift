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
    @ObservedObject var task: CareTask = CareTask()
    
    // View Parameters
    @Published var editMode: EditMode = .inactive
    
    func present(task: CareTask) {
        self.task = task
        selectedTaskId = task.id
    }
}


struct CareTaskEditor: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CareTaskType.AllTaskTypesFetchRequest) var taskTypes: FetchedResults<CareTaskType>
    
    @ObservedObject var editorConfig: CareTaskEditorConfig
    
//    var onSave: () -> Void
    
    var body: some View {
        List {
            Section(header: Text("What").font(.headline)) {
                CareTaskTypePicker(selection: $editorConfig.task.type)
            }
            
//            IntervalPicker(header: Text("Repeats").font(.headline), selection: editorConfig.task.interval)
//
//            Section {
//                UITextFieldWrapper("Notes", text: $editorConfig.task.note)
//            }
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
    static let config = CareTaskEditorConfig()
    
    static var previews: some View {
        CareTaskEditor(editorConfig: CareTaskEditorConfig())
    }
}
