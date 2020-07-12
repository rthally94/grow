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
        
        plant.$wateringInterval
            .map {
                if let interval = $0 {
                    return interval.description
                } else {
                    return "None"
                }
            }
        .assign(to: \.wateringIntervalValue, on: self)
        .store(in: &cancellables)
        
        plant.$wateringInterval
            .map { $0 != nil ? "Watering" : "Watered" }
            .assign(to: \.plantWateringTitle, on: self)
            .store(in: &cancellables)
        
        plant.$wateringInterval
            .combineLatest(plant.$careActivity)
            .map { interval, activity in
                // Check if plant has a care interval
                if let interval = interval {
                    // Format for next care activity
                    let next = interval.next(from: activity.first?.date ?? Date())
                    return Formatters.relativeDateFormatter.string(for: next)
                } else {
                    // Check if a log has been recorded
                    if let lastLogDate = activity.first?.date {
                        // Display the date of the last log
                        return Formatters.dateFormatter.string(for: lastLogDate) ?? "Nil"
                    } else {
                        return "Never"
                    }
                }
        }
        .assign(to: \.plantWateringValue, on: self)
        .store(in: &cancellables)
        
        plant.$careActivity
            .map {
                Array($0.prefix(10))
            }
        .assign(to: \.recentCareActivity, on: self)
        .store(in: &cancellables)
    }
    
    private var cancellables = [AnyCancellable]()
    
    // MARK: Properties
    
    var name: String {
        plant.name
    }
    
    // Care Cells
    @Published var plantWateringTitle: String = ""
    @Published var plantWateringValue: String = ""
    
    // Growing Conditions
    var ageValue: String {
        if let potted = plant.pottingDate, let ageString = Formatters.dateComponentsFormatter.string(from: potted, to: Date()) {
            return "Potted \(ageString) ago"
        } else {
            return "Not Potted Yet"
        }
    }
    
    @Published var wateringIntervalValue: String = ""
    
    // Recent Care Activity
    @Published var recentCareActivity = [CareActivity]()
    
    // MARK: Intents
    func addCareActivity(type: CareActivity.CareType, date: Date = Date()) {
        let activity = CareActivity(type: type, date: date)
        model.addCareActivity(activity, to: plant)
    }
    
    func deletePlant() {
        self.model.deletePlant(plant: plant)
    }
}
