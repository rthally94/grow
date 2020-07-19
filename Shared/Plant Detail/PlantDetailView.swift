//
//  PlantDetailView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/9/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var model: GrowModel
    
    var plant: Plant
    
    // Model State
    @State private var editorConfig = EditorConfig()
    
    // View State
    @State private var plantActionSheetIsPresented = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(ageValue)
                InsetGroupedSection( header: {
                    HStack {
                        Group {
                            Image(systemName: "heart.fill")
                            Text("Care Activity")
                        }
                        .font(.headline)
                        
                        Spacer()
                        Group {
                            Text(self.careActivityCount)
                            Button(action: {}, label: {Image(systemName: "chevron.right")})
                        }
                        .foregroundColor(.gray)
                        .font(.caption)
                    }
                }) {
                    HStack(alignment: .bottom) {
                        StatCell(title: Text(self.plantWateringTitle)) { Text(self.plantWateringValue) }
                        Spacer()
                    }
                    .animation(.none)
                }
                
                InsetGroupedSection(header: {
                    HStack {
                        Group {
                            Image(systemName: "scissors")
                            Text("Growing Conditions")
                        }
                        .font(.headline)
                        
                        Spacer()
                    }
                }) {
                    VStack(spacing: 20) {
                        HStack {
                            Group {
                                StatCell(title: Text("Sun Tolerance")) {
                                    Text("No Val")
                                }
                                StatCell(title: Text("Watering")) { Text(self.plantWateringValue) }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(plant.name)
        .navigationBarItems(trailing: Button(action: showActionSheet) {
            Image(systemName: "ellipsis.circle")
        })
            .actionSheet(isPresented: $plantActionSheetIsPresented) {
                ActionSheet(title: Text("Options"), buttons: [
                    ActionSheet.Button.default(Text("Log Care Activity"), action: addCareActivity),
                    ActionSheet.Button.default(Text("Edit Plant"), action: presentEditor),
                    ActionSheet.Button.destructive(Text("Delete Plant"), action: deletePlant),
                    ActionSheet.Button.cancel()
                ])
        }
        .sheet(
            isPresented: $editorConfig.isPresented,
            content: {
                NavigationView {
                    PlantEditorForm(editorConfig: self.$editorConfig, onSave: self.saveChanges)
                }
        })
    }
    
    // MARK: Actions
    private func showActionSheet() {
        plantActionSheetIsPresented.toggle()
    }
    
    private func addCareActivity() {
        withAnimation {
            let activity = CareActivity(type: .water, date: Date())
            model.addCareActivity(activity, to: plant)
        }
    }
    
    private func deletePlant() {
        withAnimation {
            self.presentationMode.wrappedValue.dismiss()
            self.model.deletePlant(plant: plant)
        }
    }
    
    private func presentEditor() {
        editorConfig.presentForEditing(plant: plant)
    }
    
    private func saveChanges() {
        let name = editorConfig.name
        let pottingDate = editorConfig.isPlanted ? editorConfig.plantedDate : nil
        
        let wateringInterval = editorConfig.waterInterval
        
        let updatedPlant = Plant(id: plant.id, name: name, pottingDate: pottingDate, sunTolerance: .fullSun, wateringInterval: wateringInterval)
        
        print(updatedPlant)
        model.addPlant(updatedPlant)
    }
}

// MARK: Computed Properties
extension PlantDetailView {
    var plantIndex: Int {
        guard let plantIndex =  model.plants.firstIndex(of: plant) else { fatalError("Plant must be in model to be in detail view.") }
        return plantIndex
    }
    
    var careActivityCount: String {
        "\(plant.careActivity.count)"
    }
    
    var plantWateringTitle: String {
        plant.wateringInterval.unit == .none ? "Watered" : "Watering"
    }
    
    var plantWateringValue: String {
        // Check if plant has a care interval
        if plant.wateringInterval.unit == .none {
            // Format for next care activity
            let next = plant.wateringInterval.next(from: plant.careActivity.first?.date ?? Date())
            return Formatters.relativeDateFormatter.string(for: next)
        } else {
            // Check if a log has been recorded
            if let lastLogDate = plant.careActivity.first?.date {
                // Display the date of the last log
                return Formatters.relativeDateFormatter.string(for: lastLogDate)
            } else {
                return "Never"
            }
        }
    }
    
    // Growing Conditions
    var ageValue: String {
        if let potted = plant.pottingDate, let ageString = Formatters.dateComponentsFormatter.string(from: potted, to: Date()) {
            return "Potted \(ageString) ago"
        } else {
            return "Not Potted Yet"
        }
    }
    
    var wateringIntervalValue: String {
        plant.wateringInterval.unit == .none ? "Watered" : "Watering"
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GrowModel()
        model.addPlant()
        
        let view = NavigationView {
            PlantDetailView(plant: model.plants[0])
        }
        
        return Group {
            view
            view.environment(\.colorScheme, .dark)
        }
    }
}
