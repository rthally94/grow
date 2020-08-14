//
//  PlantEditorForm.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

class PlantEditorConfig: ObservableObject {
    @Published var plant: Plant = Plant(context: .init(concurrencyType: .privateQueueConcurrencyType))
    let editingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = plant.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
    }
    
    func present(plant: Plant) {
        guard let parentContext = plant.managedObjectContext else { fatalError("Plant not configured with managed object context!") }
        editingContext.parent = parentContext
        
        let plants = try? editingContext.fetch(Plant.getPlantFetchRequest(with: plant.id))
        let plant = plants?.first
        self.plant = plant ?? Plant(context: editingContext)
    }
}

struct PlantEditorForm: View {
    // CoreData
    @Environment(\.managedObjectContext) var context
    
    @Binding var isPresented: Bool
    @ObservedObject var plantEditorConfig: PlantEditorConfig
    @State private var careTaskEditorConfig = CareTaskEditorConfig()
    
    var body: some View {
        Form {
            Section {
                UITextFieldWrapper("Plant Name", text: $plantEditorConfig.plant.name)
                Toggle(isOn: $plantEditorConfig.plant.isPlanted, label: { Text("Planted") })
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
        try? plantEditorConfig.editingContext.save()
        
        dismiss()
    }
    
    private func dismiss() {
        isPresented = false
    }
}

struct PlantEditorForm_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let plant = Plant(context: context)
        
        return Group {
            StatefulPreviewWrapper(PlantEditorConfig()) { state in
                NavigationView {
                    PlantEditorForm(isPresented: .constant(true), plantEditorConfig: state.wrappedValue)
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
