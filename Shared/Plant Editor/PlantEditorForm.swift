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
    @State var plant: Plant
    @State var showPlantedPicker = false
    @State var plantingDate = Date()
    @State var showWaterIntervalPicker = false
    
    init(onSave: @escaping (Plant) -> Void ) {
        let plant = Plant(name: "")
        self.init(plant: plant, onSave: {_ in} )
    }
    
    init(plant: Plant, onSave: @escaping (Plant) -> Void ) {
        self._plant = State(initialValue: plant)
        self.onSave = onSave
    }
    
    var body: some View {
        Form {
            Section {
                UITextFieldWrapper("Plant Name", text: self.$plant.name)
            }
            
            Section {
                Toggle(isOn: self.$showPlantedPicker.animation(.easeInOut), label: {Text("Planted")})
                if self.showPlantedPicker {
                    DatePicker("Planting Date", selection: self.$plantingDate, in: ...Date(), displayedComponents: [.date])
                }
            }
            
            Section {
                HStack {
                    Text("Watering Interval")
                    Spacer()
                    Text(plant.wateringInterval.description)
                    Image(systemName: "chevron.right")
                }
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
        .navigationBarItems(leading: Button("Cancel", action: dismiss), trailing: Button("Save", action: save) )
    }
    
    private func save() {
        plant.pottingDate = showPlantedPicker ? plantingDate : nil
        
        onSave(plant)
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
