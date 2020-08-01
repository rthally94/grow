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
        
        addPlant(Plant(name: newPlantName))
    }
    
    /// Adds a parameterized plant to the dataset
    /// - Parameter name: The name of the plant
    func addPlant(_ plant: Plant) {
        if let oldPlantIndex = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[oldPlantIndex] = plant
            print(plants[0])
        } else {
            plants.append(plant)
        }
    }
    
    /// Removes a plant from the dataset
    /// - Parameter plant: The plant to remove
    func deletePlant(plant: Plant) {
        if let index = plants.firstIndex(of: plant) {
            plants.remove(at: index)
        }
    }
    
    func addCareTask(_ task: CareTask , to plant: Plant) {
        if let plantIndex = plants.firstIndex(of: plant) {
            plants[plantIndex].addCareTask(task)
        }
    }
    
    func addCareTaskLog(_ log: CareTaskLog, to task: CareTask, for plant: Plant) {
        if let plantIndex = plants.firstIndex(of: plant), let careTaskIndex = plants[plantIndex].careTasks.firstIndex(of: task) {
            plants[plantIndex].careTasks[careTaskIndex].addLog(CareTaskLog())
        }
    }
    
    func deleteCareTaskLog(_ log: CareTaskLog? = nil, from task: CareTask, for plant: Plant) {
        if let plantIndex = plants.firstIndex(of: plant), let careTaskIndex = plants[plantIndex].careTasks.firstIndex(of: task) {
            if let log = log, let logIndex = plants[plantIndex].careTasks[careTaskIndex].logs.firstIndex(of: log) {
                plants[plantIndex].careTasks[careTaskIndex].logs.remove(at: logIndex)
            } else {
                plants[plantIndex].careTasks[careTaskIndex].logs.removeFirst()
            }
        }
    }
    
    func setPlantFavorite(_ state: Bool, for plant: Plant) {
        if let plantIndex = plants.firstIndex(of: plant) {
            plants[plantIndex].isFavorite = state
        }
    }
}
