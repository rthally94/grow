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
    //    /// Removes a care task from a plant.
    //    /// - Parameters:
    //    ///   - task: The task to unassign.
    //    ///   - plant: The plant the care task should be unassigned from.
    //    func removeCareTask(_ task: CareTask, from plant: Plant) {
    //        guard let plantIndex = plants.firstIndex(of: plant) else { return }
    //        guard careTaskTypes.contains(where: { $0.id == task.associatedTask }) else { return }
    //
    //        plants[plantIndex].removeCareTask(task)
    //    }
    //
    //    func addCareTaskLog(_ log: CareTaskLog, to task: CareTask, for plant: Plant) {
    //            if let plantIndex = plants.firstIndex(of: plant), let careTaskIndex = plants[plantIndex].careTasks.firstIndex(of: task) {
    //                plants[plantIndex].careTasks[careTaskIndex].addLog(CareTaskLog())
    //            }
    //        }
    //
    //        func deleteCareTaskLog(_ log: CareTaskLog? = nil, from task: CareTask, for plant: Plant) {
    //            if let plantIndex = plants.firstIndex(of: plant), let careTaskIndex = plants[plantIndex].careTasks.firstIndex(of: task) {
    //                if let log = log, let logIndex = plants[plantIndex].careTasks[careTaskIndex].logs.firstIndex(of: log) {
    //                    plants[plantIndex].careTasks[careTaskIndex].logs.remove(at: logIndex)
    //                } else {
    //                    plants[plantIndex].careTasks[careTaskIndex].logs.removeFirst()
    //                }
    //            }
    //        }
    //
    //    /// Marks a plant as favorite.
    //    /// - Parameters:
    //    ///   - state: The desired state for favorite
    //    ///   - plant: The plant to set favorite state
    //    func setPlantFavorite(_ state: Bool, for plant: Plant) {
    //        if let plantIndex = plants.firstIndex(of: plant) {
    //            plants[plantIndex].isFavorite = state
    //        }
    //    }
}

//// MARK: CareTaskType Intents
//extension GrowModel {
//
//    /// Adds a care task to the model
//    /// - Parameter task: The new task to add. Will update the existing instance if the new task's id matches and existing model in the dataset.
//    func addCareTaskType(_ task: CareTaskType) {
//        if let oldTaskIndex = careTaskTypes.firstIndex(where: { $0.id == task.id }) {
//            careTaskTypes[oldTaskIndex] = task
//        } else {
//            careTaskTypes.append(task)
//        }
//    }
//
//    /// Removes a care task from the dataset. Deletion is cascaded across all plants that utilize it.
//    /// - Parameter task: The task to delete
//    func removeCareTask( _ task: CareTaskType) {
//        guard let taskIndex = careTaskTypes.firstIndex(of: task) else { return }
//        careTaskTypes.remove(at: taskIndex)
//    }
//}
