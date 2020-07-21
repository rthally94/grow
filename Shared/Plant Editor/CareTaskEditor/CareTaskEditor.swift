//
//  CareTaskEditor.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct CareTaskEditorConfig {
    var presentedTaskId: UUID? = UUID()
    
    var name = ""
    var note = ""
    
    
    mutating func present(task: CareTask) {
        presentedTaskId = task.id
        
        name = task.name
        note = task.notes
    }
}


struct CareTaskEditor: View {
    @Binding var editorConfig: CareTaskEditorConfig
    
    var body: some View {
        List {
            Section(header: Text("What").font(.headline)) {
                UITextFieldWrapper("Name", text: $editorConfig.name)
            }
            
            IntervalPicker(header: Text("Repeats").font(.headline), onSave: onSave)
            
            Section {
                UITextFieldWrapper("Notes", text: $editorConfig.note)
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    func onSave(interval: CareInterval) {
        print(interval)
    }
}

struct CareTaskEditor_Previews: PreviewProvider {
    static let config = CareTaskEditorConfig(presentedTaskId: UUID(), name: "Task Name")
    
    static var previews: some View {
        StatefulPreviewWrapper(config) { config in
            CareTaskEditor(editorConfig: config)
        }
    }
}
