//
//  CareTaskEditor.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct CareTaskEditorConfig {
    var presentedTaskId: UUID? = UUID()
    
    var name = ""
    
    @ObservedObject var type: CareTaskType
    @ObservedObject var interval: CareTaskInterval
    
    var note = ""
    
    init() {
        type = CareTaskType(context: .init(concurrencyType: .mainQueueConcurrencyType))
        interval = CareTaskInterval(context: .init(concurrencyType: .mainQueueConcurrencyType))
    }
    
    mutating func present(task: CareTask) {
        presentedTaskId = task.id
        
        name = task.type.name
        type = task.type
        interval = task.interval
        
        note = task.notes
    }
}


struct CareTaskEditor: View {
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: CareTaskType.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CareTaskType.name_, ascending: true)]) var taskTypes: FetchedResults<CareTaskType>
    
    @Binding var editorConfig: CareTaskEditorConfig
    var onSave: () -> Void
    
    var body: some View {
        List {
            Section(header: Text("What").font(.headline)) {
                Picker("Task Type", selection: $editorConfig.name) {
                    ForEach(taskTypes, id: \.id) { type in
                        Text(type.name).tag(type.name)
                    }
                    
                    UITextFieldWrapper("New", text: $editorConfig.name)
                }

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
        presentationMode.wrappedValue.dismiss()
    }
}

struct CareTaskEditor_Previews: PreviewProvider {
    static let config = CareTaskEditorConfig()
    
    static var previews: some View {
        StatefulPreviewWrapper(config) { config in
            CareTaskEditor(editorConfig: config) {
                print(config.wrappedValue)
            }
        }
    }
}
