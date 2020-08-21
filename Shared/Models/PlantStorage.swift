//
//  PlantStorage.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/20/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import Combine
import CoreData

class PlantStorage: NSObject, ObservableObject {
    private let context: NSManagedObjectContext
    private let allPlantsController: NSFetchedResultsController<PlantMO>
    
    @Published var plants = [Plant]()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.allPlantsController = NSFetchedResultsController<PlantMO>(fetchRequest: PlantMO.allPlantsFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        allPlantsController.delegate = self
        
        do {
            try allPlantsController.performFetch()
            plants = allPlantsController.fetchedObjects?.compactMap(Plant.init) ?? []
        } catch {
            print("Fetch Failed! | \(error.localizedDescription)")
        }
    }
}

extension PlantStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        plants = allPlantsController.fetchedObjects?.compactMap(Plant.init) ?? []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            print("Updated")
        case.delete:
            print("Deleted")
        case .insert:
            print("Inserted")
        case .move:
            print("Moved")
        default:
            print("Other")
        }
    }
}

extension PlantStorage: StorageCRUD {
    func add(_ item: Plant) {
        if !plants.contains(item) {
            let plant = PlantMO(context: self.context)
            plant.id = item.id
            plant.name = item.name
            plant.isFavorite = item.isFavorite
            plant.plantingDate = item.plantingDate
            plant.careTasks = []
            
            try? context.save()
        }
    }
    
    func update(_ item: Plant) {
        if plants.contains(item), let object = allPlantsController.fetchedObjects?.first(where: {$0.id == item.id}) {
            object.name = item.name
            object.isFavorite = item.isFavorite
            object.plantingDate = item.plantingDate
            
            try? context.save()
        }
    }
    
    func remove(_ item: Plant) {
        if plants.contains(item), let object = allPlantsController.fetchedObjects?.first(where: {$0.id == item.id}) {
            context.delete(object)
        }
    }
    
    typealias Item = Plant
}
