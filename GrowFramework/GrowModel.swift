//
//  GrowModel.swift
//  GrowFramework
//
//  Created by Ryan Thally on 7/6/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

class GrowModel {
    var plantStore: PlantStore
    
    init(plants: PlantStore) {
        self.plantStore = plants
    }
    
    
}

class PlantStore {
    private var plants: [Plant] = []
    
    func addPlant() {
        let newPlantName = "Plant"
        addPlant(name: newPlantName)
    }
    
    func addPlant(name: String) {
        let newPlant = Plant(id: UUID(), name: name)
        plants.append(newPlant)
    }
    
    func getPlants() -> [Plant] {
        return plants
    }
    
    func getPlant(at index: Int) -> Plant? {
        return plants[index]
    }
    
    func updatePlant(_ oldPlant: Plant, name: String? = nil) {
        if let oldIndex = plants.firstIndex(of: oldPlant) {
            let updatedPlant = Plant(id: oldPlant.id, name: name ?? oldPlant.name)
            plants[oldIndex] = updatedPlant
        }
    }
    
    func deletePlant(plant: Plant) {
        if let index = plants.firstIndex(of: plant) {
            plants.remove(at: index)
        }
    }
}
