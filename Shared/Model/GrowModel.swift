//
//  GrowModel.swift
//  GrowFramework
//
//  Created by Ryan Thally on 7/6/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import Combine

class GrowModel: ObservableObject {
    @Published var plants = [Plant]()
}

extension GrowModel {
    /// Adds a default plant to the dataset
    func addPlant() {
        let newPlantCount = plants.reduce(0) { (count, plant) in
            plant.name.hasPrefix("New Plant") ? count + 1 : count
        }
        let newPlantName = "New Plant \(newPlantCount + 1)"
        addPlant(name: newPlantName)
    }
    
    /// Adds a parameterized plant to the dataset
    /// - Parameter name: The name of the plant
    func addPlant(name: String) {
        let newPlant = Plant(id: UUID(), name: name)
        plants.append(newPlant)
    }
    
    /// Updates a plant model in the dataset with the specified parameters
    /// - Parameters:
    ///   - oldPlant: The plant to update
    ///   - name: The new name of the plant
    func updatePlant(_ oldPlant: Plant, name: String? = nil) {
        if let oldIndex = plants.firstIndex(of: oldPlant) {
            let updatedPlant = plants[oldIndex]
            updatedPlant.name = name ?? oldPlant.name
        }
    }
    
    /// Removes a plant from the dataset
    /// - Parameter plant: The plant to remove
    func deletePlant(plant: Plant) {
        if let index = plants.firstIndex(of: plant) {
            plants.remove(at: index)
        }
    }
    
    func addCareActivity(_ care: CareActivity , to plant: Plant) {
        if let plantIndex = plants.firstIndex(of: plant) {
            plants[plantIndex].addCareActivity(care)
        }
    }
}
