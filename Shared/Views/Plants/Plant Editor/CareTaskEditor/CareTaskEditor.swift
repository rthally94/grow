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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var task: CareTask
    
    var body: some View {
        List {
            Section(header: Text("What").font(.headline)) {
                CareTaskTypePicker(task: task)
            }

            IntervalPicker()

            Section {
                UITextFieldWrapper("Notes", text: $task.note)
            }
        }
        .listStyle(GroupedListStyle())
    }
        
    func save() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct CareTaskEditor_Previews: PreviewProvider {
    static var previews: some View {
        let task = CareTask(context: .init(concurrencyType: .mainQueueConcurrencyType))
        
        return CareTaskEditor(task: task)
        
    }
}
