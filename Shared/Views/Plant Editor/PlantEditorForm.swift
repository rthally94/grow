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
    @ObservedObject var plant = Plant(context: .init(concurrencyType: .privateQueueConcurrencyType))
    
    /// Coppies the current plant instance to a new context.
    /// - Parameter context: The context to copy to
    mutating func moveToContext(context: NSManagedObjectContext) {
        // Do not copy if plant is already in context
        guard context != plant.managedObjectContext else { return }
        guard context.parent == plant.managedObjectContext else { return }
        
        self.plant = context.object(with: plant.objectID) as! Plant
    }
    
    mutating func present(plant: Plant? = nil) {
        if let _plant = plant {
            self.plant = _plant
        }
        
        isPresented = true
    }
}

struct PlantEditorForm: View {
    // CoreData
    @Environment(\.managedObjectContext) var context
    @Binding var plantEditorConfig: PlantEditorConfig
    @State private var careTaskEditorConfig = CareTaskEditorConfig()
    
    var body: some View {
        Form {
            Section {
                UITextFieldWrapper("Plant Name", text: $plantEditorConfig.plant.name)
                Toggle(isOn: plantEditorConfig.$plant.isPlanted, label: { Text("Planted") })
                if plantEditorConfig.plant.isPlanted {
                    DatePicker("Planting Date", selection: $plantEditorConfig.plant.plantingDate, in: ...Date(), displayedComponents: [.date])
                }
            }
            
            Section (header: Text("Plant Care")){
                ForEach(plantEditorConfig.plant.careTasks.sorted(), id: \.id) { task in
                    NavigationLink(
                        destination: CareTaskEditor(editorConfig: self.careTaskEditorConfig),
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
        .onAppear(perform: moveToChildContext)
    }
    
    private func moveToChildContext() {
        plantEditorConfig.moveToContext(context: context)
    }
    
    // MARK: Actions
    private func customBinding() -> Binding<UUID?> {
        let binding = Binding<UUID?>(get: {
            self.careTaskEditorConfig.task.id
        } , set: { newID in
            if let task = self.plantEditorConfig.plant.careTasks.first(where: {$0.id == newID}) {
                self.careTaskEditorConfig.present(task: task)
            }
        })
        
        return binding
    }
    
    private func addTask() {
        let task = CareTask(context: context)
        plantEditorConfig.plant.careTasks.insert(task)
        careTaskEditorConfig.present(task: task)
    }
    
    private func deleteTask(indices: IndexSet) {
        for index in indices {
            let taskIndex = plantEditorConfig.plant.careTasks.index(plantEditorConfig.plant.careTasks.startIndex, offsetBy: index)
            plantEditorConfig.plant.careTasks.remove(at: taskIndex)
        }
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("Unable to save child context!")
        }
        
        dismiss()
    }
    
    private func dismiss() {
        plantEditorConfig.isPresented = false
    }
}

struct PlantEditorForm_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let plant = Plant(context: context)
        
        return Group {
            StatefulPreviewWrapper(PlantEditorConfig()) { state in
                NavigationView {
                    PlantEditorForm(plantEditorConfig: state)
                        .environment(\.managedObjectContext, context.childContext)
                }
                .onAppear {
                    state.wrappedValue.present(plant: plant)
                }
            }
            .previewDisplayName("New Plant")
        }.environment(\.managedObjectContext, context)
    }
}
