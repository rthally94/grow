//
//  PlantEditorForm.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantEditorForm: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Save Callback
    var onSave: (Plant) -> Void
    
    // Form State
    @State var plantName = ""
    @State var showPlantedPicker = false
    @State var plantedDate = Date()
    
    @State var showWaterIntervalPicker = false
    @State var waterInterval = CareInterval()
    
    init(onSave: @escaping (Plant) -> Void ) {
        let plant = Plant(name: "")
        self.init(plant: plant, onSave: {_ in} )
    }
    
    init(plant: Plant, onSave: @escaping (Plant) -> Void ) {
        self.onSave = onSave
        
        // Setup internal state
        showPlantedPicker = plant.pottingDate != nil
        plantedDate = plant.pottingDate ?? Date()
        
        showWaterIntervalPicker = plant.wateringInterval.unit != .none
        waterInterval = plant.wateringInterval
        
    }
    
    var body: some View {
        Form {
            Section {
                UITextFieldWrapper("Plant Name", text: $plantName)
            }
            
            Section {
                Toggle(isOn: self.$showPlantedPicker.animation(.easeInOut), label: {Text("Planted")})
                if self.showPlantedPicker {
                    DatePicker("Planting Date", selection: $plantedDate, in: ...Date(), displayedComponents: [.date])
                }
            }
            
            Section {
                HStack {
                    Text("Watering Interval")
                    Spacer()
                    Text(waterInterval.description)
                    Image(systemName: "chevron.right")
                }
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
        .navigationBarItems(leading: Button("Cancel", action: dismiss), trailing: Button("Save", action: save) )
    }
    
    private func save() {
//        onSave(plant)
        dismiss()
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct PlantEditorForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                PlantEditorForm { plant in
                    print(plant)
                }
                .environmentObject(GrowModel())
            }.previewDisplayName("New Plant")
            
            NavigationView {
                PlantEditorForm(plant: Plant()) { plant in
                    print(plant)
                }
                .environmentObject(GrowModel())
            }.previewDisplayName("Existing Plant")
        }
    }
}
