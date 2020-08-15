//
//  PlantEditorForm.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantEditorConfig {
    var isPresented: Bool = false
    
    var plantName: String = "My New Plant"
    var plantIsFavorite: Bool = false
    var plantIsPlanted: Bool = false
    var plantPlantingDate: Date = Date()
    var plantCareTasks: Set<CareTask> = []
    
    mutating func present(plant: Plant) {
        if let name = plant.name_ {
            plantName = name
        }
        
        plantIsFavorite = plant.isFavorite
        plantIsPlanted = plant.isPlanted
        
        if let plantingDate = plant.plantingDate_ {
            plantPlantingDate = plantingDate
        }
        
        plantCareTasks = plant.careTasks
        
        isPresented = true
    }
}

struct PlantEditorForm: View {
    // CoreData
    @Environment(\.managedObjectContext) var context
    @Binding var editorConfig: PlantEditorConfig
    var onSave: () -> Void
    
    @State var selectedCareTaskID: UUID? = nil
    
    var body: some View {
        Form {
            Section {
                UITextFieldWrapper("Plant Name", text: $editorConfig.plantName)
                Toggle(isOn: $editorConfig.plantIsPlanted, label: { Text("Planted") })
                if editorConfig.plantIsPlanted {
                    DatePicker("Planting Date", selection: $editorConfig.plantPlantingDate, in: ...Date(), displayedComponents: [.date])
                }
            }
            
            Section (header: Text("Plant Care")){
                ForEach(editorConfig.plantCareTasks.sorted(), id: \.id) { task in
                    NavigationLink(
                        destination: CareTaskEditor(selectedTaskID: self.$selectedCareTaskID, task: task),
                        tag: task.id,
                        selection: self.$selectedCareTaskID) {
                            HStack {
                                Text(task.type?.name ?? "")
                                Spacer(minLength: 16)
                                Text(task.interval.description.capitalized).foregroundColor(.gray)
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
//    private func customBinding() -> Binding<UUID?> {
//        let binding = Binding<UUID?>(get: {
//            self.selectedCareTaskID
//        } , set: { newID in
//            self.selectedCareTaskID = newID
//        })
//
//        return binding
//    }
    
    private func addTask() {
        let task = CareTask(context: context)
        editorConfig.plantCareTasks.insert(task)
        
        selectedCareTaskID = task.id
    }
    
    private func deleteTask(indices: IndexSet) {
        for index in indices {
            let taskIndex = editorConfig.plantCareTasks.index(editorConfig.plantCareTasks.startIndex, offsetBy: index)
            editorConfig.plantCareTasks.remove(at: taskIndex)
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
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let plant = Plant(context: context)
        
        return Group {
            StatefulPreviewWrapper(PlantEditorConfig()) { state in
                NavigationView {
                    PlantEditorForm(editorConfig: state) {
                        print("Saved")
                    }
                        .onAppear {
                            state.wrappedValue.present(plant: plant)
                    }
                }
            }
            .environment(\.managedObjectContext, context)
            .previewDisplayName("New Plant")
        }.environment(\.managedObjectContext, context)
    }
}
