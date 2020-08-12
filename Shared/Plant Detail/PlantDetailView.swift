//
//  PlantDetailView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/9/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantDetailView: View {
    @ObservedObject var plant: Plant
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    // Model State
    @ObservedObject private var editorConfig = PlantEditorConfig()
    
    // View State
    @State private var plantActionSheetIsPresented = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(ageValue)
                    Spacer()
                }.padding(.bottom)
                
                if plant.careTasks.count > 0 {
                    Section(header:
                        Text("Care Tasks")
                        .font(.headline)
                    ) {
                        VStack(spacing: 20) {
                            ForEach(Array(plant.careTasks), id: \.id) { task in
                                StatCell(title: Text(task.type.name)) {
                                    Text(task.interval.description)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.systemGroupedBackground))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(plant.name)
        .navigationBarItems(trailing: Button(action: showActionSheet) {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
        })
            .actionSheet(isPresented: $plantActionSheetIsPresented) {
                ActionSheet(title: Text("Options"), buttons: [
                    ActionSheet.Button.default(Text("Edit Plant"), action: presentEditor),
                    ActionSheet.Button.destructive(Text("Delete Plant"), action: deletePlant),
                    ActionSheet.Button.cancel()
                ])
        }
        .sheet(
            isPresented: $editorConfig.isPresented,
            content: {
                NavigationView {
                    PlantEditorForm(editorConfig: self.editorConfig, onSave: self.saveChanges)
                    .environment(\.managedObjectContext, self.context)
                }
        })
    }
    
    // MARK: Actions
    private func showActionSheet() {
        plantActionSheetIsPresented.toggle()
    }
    
    private func presentEditor() {
        editorConfig.presentForEditing(plant: plant)
    }
    
    // MARK: Intents
    private func deletePlant() {
        withAnimation {
            self.presentationMode.wrappedValue.dismiss()
//            self.model.deletePlant(plant: plant)
        }
    }
    
    private func saveChanges() {
        try? editorConfig.context.save()
    }
}

// MARK: Computed Properties
extension PlantDetailView {
//    var plantIndex: Int {
//        guard let plantIndex =  model.plants.firstIndex(of: plant) else { fatalError("Plant must be in model to be in detail view.") }
//        return plantIndex
//    }
    
    //    var careTaskLogCount: String {
    //        "\(plant.careTaskLogs.count)"
    //    }
    //
    //    var plantWateringTitle: String {
    //        plant.wateringInterval.unit == .none ? "Watered" : "Watering"
    //    }
    //
    //    var plantWateringValue: String {
    //        // Check if plant has a care interval
    //        if plant.wateringInterval.unit == .none {
    //            // Format for next care activity
    //            let next = plant.wateringInterval.next(from: plant.careActivity.first?.date ?? Date())
    //            return Formatters.relativeDateFormatter.string(for: next)
    //        } else {
    //            // Check if a log has been recorded
    //            if let lastLogDate = plant.careActivity.first?.date {
    //                // Display the date of the last log
    //                return Formatters.relativeDateFormatter.string(for: lastLogDate)
    //            } else {
    //                return "Never"
    //            }
    //        }
    //    }
    
    // Growing Conditions
    var ageValue: String {
        if let potted = plant.plantingDate {
            let ageString = Formatters.relativeDateFormatter.string(for: potted)
            return "Planted \(ageString)"
        } else {
            return "Not Planted"
        }
    }
    
    //    var wateringIntervalValue: String {
    //        plant.wateringInterval.unit == .none ? "Watered" : "Watering"
    //    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let plant = Plant.create(context: context)
        
        let view = NavigationView {
            PlantDetailView(plant: plant)
        }.environment(\.managedObjectContext, context)
        
        return Group {
            view
            view.environment(\.colorScheme, .dark)
        }
    }
}
