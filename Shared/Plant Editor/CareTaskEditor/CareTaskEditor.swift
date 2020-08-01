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
    var interval = CareInterval()
    var note = ""
    
    
    mutating func present(task: CareTask) {
        presentedTaskId = task.id
        
        name = task.name
        interval = task.interval
        note = task.notes
    }
}


struct CareTaskEditor: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var editorConfig: CareTaskEditorConfig
    var onSave: () -> Void
    
    var body: some View {
        List {
            Section(header: Text("What").font(.headline)) {
                UITextFieldWrapper("Name", text: $editorConfig.name)
            }
            
            IntervalPicker(header: Text("Repeats").font(.headline), selection: $editorConfig.interval)
            
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
    static let config = CareTaskEditorConfig(presentedTaskId: UUID(), name: "Task Name")
    
    static var previews: some View {
        StatefulPreviewWrapper(config) { config in
            CareTaskEditor(editorConfig: config) {
                print(config.wrappedValue)
            }
        }
    }
}
