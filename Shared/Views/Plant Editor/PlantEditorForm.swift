//
//  PlantEditorForm.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantEditorForm: View {
    private struct EditorConfig {
        let plant: Plant
        
        var name: String
        var plantingDate: Date
        var isPlanted: Bool
        var careTasks: [CareTask]
        
        func updatedPlant() -> Plant {
            return Plant(
                id: plant.id,
                name: name,
                plantingDate: isPlanted ? plantingDate : nil,
                isFavorite: false,
                careTasks: careTasks)
        }
        
        init() {
            let plant = Plant(id: UUID(), name: "", plantingDate: nil, isFavorite: false, careTasks: [])
            self.init(plant: plant)
        }
        
        init(plant: Plant) {
            self.plant = plant
            name = plant.name
            plantingDate = plant.plantingDate ?? Date()
            isPlanted = plant.plantingDate != nil
            careTasks = plant.careTasks
        }
    }
    
    @EnvironmentObject var growModel: GrowModel
    @State private var editorConfig: EditorConfig
    
    @State private var selectedTask: CareTask?
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>, plant: Plant? = nil) {
        let newPlant: Plant
        if let unwrappedPlant = plant {
            newPlant = unwrappedPlant
        } else {
            newPlant = Plant(name: "My New Plant")
        }
        
        self._editorConfig = State<EditorConfig>(wrappedValue: EditorConfig(plant: newPlant))
        self._isPresented = isPresented
    }
    
    var body: some View {
        Form {
            Section {
                UITextFieldWrapper("Plant Name", text: $editorConfig.name)
                Toggle(isOn: $editorConfig.isPlanted, label: { Text("Planted") })
                if editorConfig.isPlanted {
                    DatePicker("Planting Date", selection: $editorConfig.plantingDate, in: ...Date(), displayedComponents: [.date])
                }
            }
            
            Section (header: Text("Plant Care")) {
                ForEach( Array(editorConfig.plant.careTasks.indices), id: \.self) { index in
                    NavigationLink(destination: CareTaskEditor(careTask: self.$editorConfig.careTasks[index] )) {
                        HStack {
                            Text(self.editorConfig.plant.careTasks[index].type?.name ?? "")
                            Spacer(minLength: 16)
                            Text(self.editorConfig.plant.careTasks[index].interval.description.capitalized).foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteTask(indices:))
                
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
    private func addTask() {
        // TODO: Implement add task intent
        let newTask = CareTask()
        growModel.addCareTask(newTask, to: editorConfig.plant)
    }
    
    private func deleteTask(indices: IndexSet) {
        // TODO: Implement delete task intent
    }
    
    private func save() {
        growModel.updatePlant(editorConfig.updatedPlant())
        dismiss()
    }
    
    private func dismiss() {
        isPresented = false
    }
}

struct PlantEditorForm_Previews: PreviewProvider {
    static var previews: some View {
        let plant = Plant(name: "My New Plant")
        
        return Group {
            NavigationView {
                PlantEditorForm(isPresented: .constant(true), plant: plant)
            }
            .previewDisplayName("New Plant")
        }
    }
}
