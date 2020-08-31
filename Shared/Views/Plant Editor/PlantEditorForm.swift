//
//  PlantEditorForm.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct PlantEditorForm: View {
    @EnvironmentObject var growModel: GrowModel
    @ObservedObject var plant: PlantMO
        
    var isPlantedBinding: Binding<Bool> {
        Binding<Bool>(get: { self.plant.plantingDate != nil }, set: { self.plant.plantingDate = $0 ? Date() : nil})
    }
    
    var plantingDateBinding: Binding<Date> {
        Binding<Date>(get: { self.plant.plantingDate ?? Date() }, set: { self.plant.plantingDate = $0 } )
    }
    
    var careTasks: [CareTaskMO] {
        plant.careTasks.map { $0 }
    }
    
    // MARK: Views
    var body: some View {
        Form {
            Section {
                plantInfo
            }
            
            Section (header: Text("Plant Care")) {
                taskInfo
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
        .navigationBarItems(leading: Button("Cancel", action: dismiss), trailing: Button("Save", action: save))
    }
    
    var plantInfo: some View {
        Group {
            UITextFieldWrapper("Plant Name", text: $plant.name)
            Toggle(isOn: isPlantedBinding.animation(), label: { Text("Planted") })
            if isPlantedBinding.wrappedValue {
                DatePicker("on", selection: plantingDateBinding, in: ...Date(), displayedComponents: [.date])
            }
        }
    }
    
    var taskInfo: some View {
        Group {
            ForEach(careTasks, id: \.id) { task in
                NavigationLink(destination: CareTaskEditor(task: task)) {
                    HStack {
                        Text(task.type.name)
                        Spacer(minLength: 16)
                        Text(task.interval.unit.description.capitalized).foregroundColor(.gray)
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
    
    // MARK: Actions
    private func addTask() {
        guard let context = plant.managedObjectContext else { return }
        let task = CareTaskMO(context: context)
        task.id_ = UUID()
        task.logs_ = []
        
        plant.addToCareTasks_(task)
    }
    
    private func deleteTask(indices: IndexSet) {
        // TODO: Implement delete task intent
        guard let context = plant.managedObjectContext else { return }
        for index in indices {
            context.delete(careTasks[index])
        }
    }
    
    private func save() {
        growModel.savePlantForEditing()
    }
    
    private func dismiss() {
        growModel.discardPlantForEditing()
    }
}

struct PlantEditorForm_Previews: PreviewProvider {
    static var previews: some View {
        let model = GrowModel(context: .init(concurrencyType: .mainQueueConcurrencyType))
        model.addPlant()
        
        guard let plant = model.plantStorage.plants.first else { fatalError("Plant not found in model storage") }
        model.selectPlantForEditing(plant)
        
        return Group {
            NavigationView {
                PlantEditorForm(plant: model.selectedPlantForEditing!)
            }
            .environmentObject(model)
            .previewDisplayName("New Plant")
        }
    }
}
