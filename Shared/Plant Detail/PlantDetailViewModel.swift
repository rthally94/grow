//
//  PlantDetailViewModel.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/12/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class PlantDetailViewModel: ObservableObject {
    var model: GrowModel
    @ObservedObject var plant: Plant
    
    init(model: GrowModel, plant: Plant) {
        self.model = model
        self.plant = plant
    }
    
    // MARK: Properties
    
    var name: String {
        plant.name
    }
    
    // Care Cells
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
    
    // MARK: Intents
    func addCareActivity(type: CareActivity.CareType, date: Date = Date()) {
        let activity = CareActivity(type: type, date: date)
        model.addCareActivity(activity, to: plant)
    }
    
    func deletePlant() {
        self.model.deletePlant(plant: plant)
    }
}
