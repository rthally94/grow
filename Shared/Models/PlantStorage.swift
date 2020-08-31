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
    
    @Published var plants = [PlantMO]()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        self.allPlantsController = NSFetchedResultsController<PlantMO>(fetchRequest: PlantMO.allPlantsFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        allPlantsController.delegate = self
        
        do {
            try allPlantsController.performFetch()
            plants = allPlantsController.fetchedObjects ?? []
        } catch {
            print("Fetch Failed! | \(error.localizedDescription)")
        }
    }
}

extension PlantStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        plants = allPlantsController.fetchedObjects ?? []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            print("Updated plant")
        case.delete:
            print("Deleted plant")
        case .insert:
            print("Inserted plant")
        case .move:
            print("Moved plant")
        default:
            print("Other plant")
        }
    }
}

extension PlantStorage: StorageCRUD {
    @discardableResult func create() -> PlantMO {
        let plantsWithNewNameRequest = PlantMO.allPlantsFetchRequest()
        plantsWithNewNameRequest.predicate = NSPredicate(format: "name_ MATCHES %@", "My New Plant \\d*$")
        
        let newPlantCount: Int
        do {
            let plants = try context.fetch(plantsWithNewNameRequest)
            newPlantCount = plants.count
        } catch {
            print(error)
            newPlantCount = 0
        }
//        let newPlantCount = try? plantsWithNewNameRequest.execute().count
        
        let plant = PlantMO(context: context)
        plant.name = "My New Plant \(newPlantCount + 1)"
        plant.isFavorite = false
        plant.plantingDate = nil
        plant.careTasks = []
        
        try? context.save()
        return plant
    }
    
    func update(_ item: PlantMO, name: String? = nil, isFavorite: Bool? = nil, plantingDate: Date? = nil, careTasks: Set<CareTaskMO>? = nil) {
        guard item.managedObjectContext == context else { return }
        
        item.name = name ?? item.name
        item.isFavorite = isFavorite ?? item.isFavorite
        item.plantingDate = plantingDate ?? item.plantingDate
        item.careTasks = careTasks ?? item.careTasks
        
        try? context.save()
    }
    
    func delete(_ item: PlantMO) {
        context.delete(item)
        
        try? context.save()
    }
    
    typealias Item = PlantMO
}
