//
//  PlantEditorForm.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct EditorConfig {
    var isPresented: Bool = false
    
    var name = ""
    
    var isPlanted = false
    var plantedDate = Date()
    
    var sunTolerance = SunTolerance.fullShade
    
    var hasWaterInterval = false
    var waterInterval = CareInterval()
    
    mutating func presentForEditing(plant: Plant) {
        name = plant.name
        
        isPlanted = plant.pottingDate != nil
        plantedDate = plant.pottingDate ?? Date()
        
        hasWaterInterval = plant.wateringInterval.unit != .none
        waterInterval = plant.wateringInterval
        
        isPresented = true
    }
}

struct PlantEditorForm: View {
    @Binding var editorConfig: EditorConfig
    // Save Callback
    var onSave: () -> Void
    
    var body: some View {
        Form {
            Section {
                UITextFieldWrapper("Plant Name", text: $editorConfig.name)
                Toggle(isOn: $editorConfig.isPlanted.animation(.easeInOut), label: {Text("Planted")})
                if editorConfig.isPlanted {
                    DatePicker("Planting Date", selection: $editorConfig.plantedDate, in: ...Date(), displayedComponents: [.date])
                }
            }
            
            Section {
                HStack {
                    Text("Sun Tolerance")
                    Spacer()
                    Text(editorConfig.sunTolerance.name)
                    Image(systemName: "chevron.right")
                }
                
                HStack {
                    Text("Watering Interval")
                    Spacer()
                    Text(editorConfig.waterInterval.description)
                    Image(systemName: "chevron.right")
                }
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
        .navigationBarItems(leading: Button("Cancel", action: dismiss), trailing: Button("Save", action: save) )
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
                StatefulPreviewWrapper(EditorConfig()) { config in
                    PlantEditorForm(editorConfig: config) {
                        print(config)
                    }
                    .environmentObject(GrowModel())
                }
            }.previewDisplayName("New Plant")
        }
    }
}
