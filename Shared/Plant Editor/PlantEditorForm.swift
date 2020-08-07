//
//  PlantEditorForm.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct EditorConfig {
    var isPresented = false
    
    var name = ""
    
    var isPlanted = false
    var plantedDate = Date()
    
    var careTasks = Set<CareTask>()
    
    mutating func presentForEditing(plant: Plant) {
        name = plant.name
        isPlanted = plant.plantingDate != nil
        plantedDate = plant.plantingDate ?? Date()
        careTasks = plant.careTasks
        
        isPresented = true
    }
}

struct PlantEditorForm: View {
    @Binding var editorConfig: EditorConfig
    @State private var taskEditorConfig = CareTaskEditorConfig()
    
    // Save Callback
    var onSave: () -> Void
    
    var body: some View {
        Form {
            Section {
                UITextFieldWrapper("Plant Name", text: $editorConfig.name)
                Toggle(isOn: $editorConfig.isPlanted.animation(.easeInOut), label: {Text("Planted")})
                if editorConfig.isPlanted {
                    DatePicker("Planting Date", selection: $editorConfig.plantedDate, in: ...Date(), displayedComponents: [.date])
                }
            }
            
            Section (header: Text("Plant Care")){
                ForEach(editorConfig.careTasks.sorted(), id: \.id) { task in
                    NavigationLink(
                        destination: CareTaskEditor(editorConfig: self.$taskEditorConfig, onSave: self.saveTask),
                        tag: task.id,
                        selection: self.customBinding()) {
                            HStack {
                                Text(task.type.name)
                                Spacer(minLength: 16)
                                Text(task.interval.description.capitalized).foregroundColor(.gray)
                            }
                        }
                }
                
                Button(action: addTask, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("add task")
                    }
                })
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
        .navigationBarItems(leading: Button("Cancel", action: dismiss), trailing: Button("Save", action: save))
    }
    
    // MARK: Actions
    private func customBinding() -> Binding<UUID?> {
        let binding = Binding<UUID?>(get: {
            self.taskEditorConfig.presentedTaskId
        } , set: { newID in
            if let task = self.editorConfig.careTasks.first(where: {$0.id == newID}) {
                self.taskEditorConfig.present(task: task)
            }
        })
        
        return binding
    }
    
    private func addTask() {
        let task = CareTask()
        task.type.name = ""
        editorConfig.careTasks.insert(task)
        
        taskEditorConfig.present(task: task)
    }
    
    private func saveTask() {
        if let index = editorConfig.careTasks.firstIndex(where: { $0.id == taskEditorConfig.presentedTaskId} ) {
            editorConfig.careTasks[index].type.name = taskEditorConfig.name
            editorConfig.careTasks[index].interval = taskEditorConfig.interval
            editorConfig.careTasks[index].notes = taskEditorConfig.note
        }
    }
    
    private func save() {
        onSave()
        dismiss()
    }
    
    private func dismiss() {
        editorConfig.isPresented = false
    }
}

struct PlantEditorForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                StatefulPreviewWrapper(EditorConfig()) { config in
                    PlantEditorForm(editorConfig: config) {
                        print(config)
                    }
                }
            }.previewDisplayName("New Plant")
        }
    }
}
