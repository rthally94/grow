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
    
    var careTasks = [CareTask]()
    
    mutating func presentForEditing(plant: Plant) {
        isPresented = true
        
        name = plant.name
        isPlanted = plant.pottingDate != nil
        plantedDate = plant.pottingDate ?? Date()
        careTasks = plant.careTasks
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
                ForEach(editorConfig.careTasks) { task in
                    NavigationLink(task.name, destination: CareTaskEditor(editorConfig: self.$taskEditorConfig), tag: task.id, selection: self.$taskEditorConfig.presentedTaskId)
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
        .navigationBarItems(leading: Button("Cancel", action: dismiss), trailing: Button("Save", action: save) )
    }
    
    // MARK: Actions
    private func addTask() {
        let task = CareTask()
        editorConfig.careTasks.append(task)
        
        taskEditorConfig.present(task: task)
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
                    .environmentObject(GrowModel())
                }
            }.previewDisplayName("New Plant")
        }
    }
}
