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
    @Environment(\.managedObjectContext)
    var viewContext
    
    @FetchRequest(fetchRequest: CareTaskType.allTypesFetchRequest()) var allTypes: FetchedResults<CareTaskType>
    
    @ObservedObject var task: CareTask
    
    @State var editMode: EditMode = .inactive
    
    @State var newTypeName: String = ""
    @State var textFieldIsFirstResponder: Bool = true
    
    var isEditing: Bool {
        editMode == .active
    }
    
    var builtInTypes: [CareTaskType] {
        allTypes.filter{ $0.builtIn }
    }
    
    var userTypes: [CareTaskType] {
        allTypes.filter{ !$0.builtIn }
    }
    
    var body: some View {
        NavigationLink(destination: child, label: {
            HStack {
                Text(task.type.name)
            }
        })
    }
    
    var child: some View {
        List {
            Section {
                ForEach(builtInTypes, id: \.self) { type in
                    self.button(for: type)
                }
            }
            
            Section(header: Text("User")) {
                ForEach(userTypes, id: \.self) { type in
                    self.button(for: type)
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
    }
    
    func button(for type: CareTaskType) -> some View {
        Button(action: { self.task.type = type } , label: {
            HStack {
                Text(type.name)
                Spacer()
                
                if type == self.task.type {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
            .contentShape(Rectangle())
            
        })
            .buttonStyle(PlainButtonStyle())
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
        // TOOD: Implement care task type deletion
    }
}

struct CareTaskTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        return CareTaskTypePicker(task: CareTask(context: .init(concurrencyType: .mainQueueConcurrencyType)))
    }
}
