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

protocol StorageCRUD {
    associatedtype Item
    func add(_ item: Item) -> Void
    func update(_ item: Item) -> Void
    func remove(_ item: Item) -> Void
}

class GrowModel: ObservableObject {
    let context: NSManagedObjectContext
    var cancellables = [AnyCancellable]()
    
    private var plantStorage: PlantStorage
    var plants: [Plant] {
        return plantStorage.plants
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        plantStorage = PlantStorage(context: context)
        cancellables.append(plantStorage.$plants
            .sink { _ in
                self.objectWillChange.send()
        })
    }
    
    deinit {
        for item in cancellables {
            item.cancel()
        }
    }
}

// MARK: PLant Intents
extension GrowModel {
    /// Adds a default plant to the dataset
    func addPlant() {
        let newPlantCount = plantStorage.plants.reduce(0) { (count, plant) in
            plant.name.hasPrefix("New Plant") ? count + 1 : count
        }
        let newPlantName = "New Plant \(newPlantCount + 1)"
        
        addPlant(Plant(name: newPlantName))
    }
    
    /// Adds a parameterized plant to the dataset
    /// - Parameter name: The name of the plant
    func addPlant(_ plant: Plant) {
        plantStorage.add(plant)
    }
    
    /// Removes a plant from the dataset
    /// - Parameter plant: The plant to remove
    func removePlant(_ plant: Plant) {
        plantStorage.remove(plant)
    }
    
    func updatePlant(_ plant: Plant) {
        plantStorage.update(plant)
    }
    
    //    /// Adds a care task to a plant in the dataset.
    //    /// - Parameters:
    //    ///   - task: The task to assign
    //    ///   - plant: The plant the task will be assigned to.
    //    func addCareTask(_ task: CareTask, to plant: Plant) {
    //        guard let plantIndex = plants.firstIndex(of: plant) else { return }
    //        guard careTaskTypes.contains(where: { $0.id == task.associatedTask }) else { return }
    //
    //        plants[plantIndex].addCareTask(task)
    //    }
    //
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
