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
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CareTaskType.AllTaskTypesFetchRequest) var taskTypes: FetchedResults<CareTaskType>
    
    @State var editMode: EditMode = .inactive
    @Binding var selection: CareTaskType
    
    @State var newTypeName: String = ""
    @State var textFieldIsFirstResponder: Bool = true
    
    var isEditing: Bool {
        editMode == .active
    }
    
    var body: some View {
        NavigationLink(destination: child, label: {
            HStack {
                Text(selection.name)
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
            let type = CareTaskType(context: context)
            type.name = newTypeName
            
            try? context.save()
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
            context.delete(type)
        }
        
        try? context.save()
    }
}

struct CareTaskTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        let type = CareTaskType(context: context)
        type.name = "Watering"
        
        return StatefulPreviewWrapper(type) { state in
            CareTaskTypePicker(selection: state)
        }
    }
}
