//
//  CareTaskTypePicker.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/10/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct CareTaskTypePicker: View {
    @EnvironmentObject var growModel: GrowModel
    
    var taskTypes: [CareTaskType] = []
    
    @Binding var selection: CareTaskType?
    @State var editMode: EditMode = .inactive
    
    @State var newTypeName: String = ""
    @State var textFieldIsFirstResponder: Bool = true
    
    var isEditing: Bool {
        editMode == .active
    }
    
    var body: some View {
        NavigationLink(destination: child, label: {
            HStack {
                Text(selection?.name ?? "Select Task Type")
            }
        })
    }
    
    var child: some View {
        List {
            ForEach(taskTypes, id: \.self) { type in
                Button(action: { self.selection = type } , label: {
                    HStack {
                        Text(type.name)
                        Spacer()
                        
                        if type == self.selection {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    
                })
                .buttonStyle(PlainButtonStyle())
            }
            .onDelete(perform: onTaskTypeDelete(indices:))
            
            if isEditing {
                UITextFieldWrapper("New Type", text: $newTypeName, isFirstResponder: $textFieldIsFirstResponder, onCommit: textFieldDidEndEditing)
            }
            
            Button(action: addTaskButtonDidPress, label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add New")
                }})
        }
    }
    
    func textFieldDidEndEditing() {
        if newTypeName != "" {
            // TODO: Implement new task type intent
        }
        
        editMode = .inactive
    }
    
    func addTaskButtonDidPress() {
        newTypeName = ""
        
        withAnimation {
            editMode = .active
        }
    }
    
    func onTaskTypeDelete(indices: IndexSet) {
        let objects = indices.compactMap { taskTypes[$0] }
        for type in objects {
            // TODO: Implement delete task type intent
        }
    }
}

struct CareTaskTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        return StatefulPreviewWrapper(CareTaskType(name: "Default")) { state in
            CareTaskTypePicker(selection: state)
        }
    }
}
