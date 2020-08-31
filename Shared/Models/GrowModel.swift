//
//  GrowModel.swift
//  GrowFramework
//
//  Created by Ryan Thally on 7/6/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData
import Combine

class GrowModel: ObservableObject {
    let context: NSManagedObjectContext
    
    private var cancellables = Set<AnyCancellable>()
    
    let plantStorage: PlantStorage
    let careTaskStorage: CareTaskStorage
    let careTaskTypeStorage: CareTaskTypeStorage
    
    @Published var selectedPlantForEditing: PlantMO?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        plantStorage = PlantStorage(context: context)
        careTaskStorage = CareTaskStorage(context: context)
        careTaskTypeStorage = CareTaskTypeStorage(context: context)
        
        plantStorage.$plants
            .map { _ in }
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellables)
        
        careTaskStorage.$tasks
            .map { _ in }
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellables)
        
        careTaskTypeStorage.$types
            .map { _ in }
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellables)
    }
    
    deinit {
        for item in cancellables {
            item.cancel()
        }
    }
}

// MARK: Plant Intents
extension GrowModel {
    /// Adds a default plant to the dataset
    func addPlant() {
        plantStorage.create()
    }
    
    /// Adds a parameterized plant to the dataset
    /// - Parameter name: The name of the plant
    func addPlant(name: String? = nil, isFavorite: Bool? = nil, plantingDate: Date? = nil, careTasks: Set<CareTaskMO>? = nil) {
        let newPlant = plantStorage.create()
        updatePlant(newPlant, name: name, isFavorite: isFavorite, plantingDate: plantingDate, careTasks: careTasks)
    }
    
    /// Removes a plant from the dataset
    /// - Parameter plant: The plant to remove
    func removePlant(_ plant: PlantMO) {
        plantStorage.delete(plant)
    }
    
    func updatePlant(_ plant: PlantMO, name: String? = nil, isFavorite: Bool? = nil, plantingDate: Date? = nil, careTasks: Set<CareTaskMO>? = nil) {
        plantStorage.update(plant, name: name, isFavorite: isFavorite, plantingDate: plantingDate, careTasks: careTasks)
    }
    
    func selectPlantForEditing(_ plant: PlantMO) {
        // Set as selected
        selectedPlantForEditing = plant
    }
    
    func discardPlantForEditing() {
        // Clears selection and removes child context ( removes changes )
        selectedPlantForEditing = nil
        context.rollback()
    }
    
    func savePlantForEditing() {
        // Only push changes if selectedPlant is in child context
        try? context.save()
        
        selectedPlantForEditing = nil
    }
}

// CareTaskType Intents
extension GrowModel {
    func addCareTaskType(name: String) {
        careTaskTypeStorage.create(name: name)
    }
    
    func removeCareTaskType(indices: IndexSet) {
        for index in indices {
            careTaskTypeStorage.delete(careTaskTypeStorage.types[index])
        }
    }
}
