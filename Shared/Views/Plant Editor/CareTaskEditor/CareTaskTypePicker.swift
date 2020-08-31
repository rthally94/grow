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
    typealias CareTaskType = CareTaskTypeMO
    @EnvironmentObject var growModel: GrowModel
    @ObservedObject var task: CareTaskMO
    
    @State var editMode: EditMode = .inactive
    
    @State var newTypeName: String = ""
    @State var textFieldIsFirstResponder: Bool = true
    
    var isEditing: Bool {
        editMode == .active
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
                ForEach(growModel.careTaskTypeStorage.types.filter { $0.builtIn }, id: \.id) { type in
                    self.button(for: type)
                }
            }
            
            Section(header: Text("User")) {
                ForEach(growModel.careTaskTypeStorage.types.filter { !$0.builtIn }, id: \.id) { type in
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
    
    func button(for type: CareTaskTypeMO) -> some View {
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
            growModel.addCareTaskType(name: newTypeName)
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
        growModel.removeCareTaskType(indices: indices)
    }
}

struct CareTaskTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        return CareTaskTypePicker(task: CareTaskMO(context: .init(concurrencyType: .mainQueueConcurrencyType)))
    }
}
