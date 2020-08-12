//
//  PlantEditorForm.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

class PlantEditorConfig: ObservableObject {
    // View Properties
    @Published var isPresented: Bool = false
    
    // CoreData
    private(set) var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    @ObservedObject var plant: Plant = Plant()
    
    // Plant Properties
    lazy var plantingdDate = Binding<Date>(get: { self.plant.plantingDate ?? Date() }, set: { self.plant.plantingDate = $0 })
    lazy var isPlanted = Binding<Bool>(get: { self.plant.plantingDate != nil }, set: { self.plant.plantingDate = $0 ? Date() : nil })
    
    func presentForEditing(plant: Plant) {
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = plant.managedObjectContext
        
        guard let entityName = plant.entity.name else { return }
        let copy = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        let attributes = plant.entity.attributesByName
        for (attrKey, _) in attributes {
            copy.setValue( plant.value(forKey: attrKey), forKey: attrKey)
        }
        
        self.plant = copy as! Plant
        
        isPresented = true
    }
}

struct PlantEditorForm: View {
    @ObservedObject var editorConfig: PlantEditorConfig
    @ObservedObject private var careTaskEditorConfig = CareTaskEditorConfig()
    
    // Save Callback
    var onSave: () -> Void
    
    var body: some View {
        Form {
            Section {
                UITextFieldWrapper("Plant Name", text: $editorConfig.plant.name)
                Toggle(isOn: editorConfig.isPlanted, label: { Text("Planted") })
                if editorConfig.isPlanted.wrappedValue {
                    DatePicker("Planting Date", selection: editorConfig.plantingdDate, in: ...Date(), displayedComponents: [.date])
                }
            }
            
            Section (header: Text("Plant Care")){
                ForEach(editorConfig.plant.careTasks.sorted(), id: \.id) { task in
                    NavigationLink(
                        destination: CareTaskEditor(editorConfig: self.careTaskEditorConfig, onSave: self.saveTask),
                        tag: task.id,
                        selection: self.customBinding()) {
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
    private func customBinding() -> Binding<UUID?> {
        let binding = Binding<UUID?>(get: {
            self.careTaskEditorConfig.selectedTaskId
        } , set: { newID in
            if let task = self.editorConfig.plant.careTasks.first(where: {$0.id == newID}) {
                self.careTaskEditorConfig.present(task: task)
            }
        })
        
        return binding
    }
    
    private func addTask() {
        let task = CareTask(context: editorConfig.context)
        editorConfig.plant.careTasks.insert(task)
        careTaskEditorConfig.present(task: task)
    }
    
    private func deleteTask(indices: IndexSet) {
        for index in indices {
            let taskIndex = editorConfig.plant.careTasks.index(editorConfig.plant.careTasks.startIndex, offsetBy: index)
            editorConfig.plant.careTasks.remove(at: taskIndex)
        }
    }
    
    private func saveTask() {
        if let index = editorConfig.plant.careTasks.firstIndex(where: { $0.id == careTaskEditorConfig.selectedTaskId} ) {
            editorConfig.plant.careTasks[index].type = careTaskEditorConfig.type
            editorConfig.plant.careTasks[index].interval = careTaskEditorConfig.interval
            editorConfig.plant.careTasks[index].notes = careTaskEditorConfig.note
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
                PlantEditorForm(editorConfig: PlantEditorConfig()) {
                }
            }.previewDisplayName("New Plant")
        }
    }
}
