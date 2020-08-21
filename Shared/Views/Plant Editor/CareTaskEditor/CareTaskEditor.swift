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
    @Binding var careTask: CareTask
    
    var body: some View {
        List {
            Section(header: Text("What").font(.headline)) {
                CareTaskTypePicker(selection: $careTask.type)
            }

            IntervalPicker(header: Text("Repeats").font(.headline), selection: $careTask.interval)

            Section {
                UITextFieldWrapper("Notes", text: $careTask.notes)
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
        let type = CareTaskType(name: "Default")
        let interval = CareInterval()
        let task = CareTask(type: type, interval: interval, notes: "", logs: [])
        
        return StatefulPreviewWrapper(task) { state in
            CareTaskEditor(careTask: state)
        }
    }
}
