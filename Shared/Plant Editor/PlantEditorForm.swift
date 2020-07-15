//
//  PlantEditorForm.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantEditorForm: View {
    @EnvironmentObject var model: GrowModel
    @ObservedObject private var plant: Plant
    
    init(plant: Plant) {
        self._plant = ObservedObject(initialValue: plant)
    }
    
    var body: some View {
        Form {
            UITextFieldWrapper("Name", text: $plant.name)
            Text(plant.name)
        }
    }
}

struct PlantEditorForm_Previews: PreviewProvider {
    static var previews: some View {
        PlantEditorForm(plant: Plant()).environmentObject(GrowModel())
    }
}
