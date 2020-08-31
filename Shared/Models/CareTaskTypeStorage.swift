//
//  CareTaskStorage.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/24/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import Combine
import CoreData

class CareTaskTypeStorage: NSObject, ObservableObject {
    private let context: NSManagedObjectContext
    private let allTypesController: NSFetchedResultsController<CareTaskTypeMO>
    
    @Published var types = [CareTaskTypeMO]()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        allTypesController = NSFetchedResultsController(fetchRequest: CareTaskTypeMO.allTypesFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "builtIn", cacheName: nil)
        
        super.init()
        
        allTypesController.delegate = self
        
        do {
            try allTypesController.performFetch()
            types = allTypesController.fetchedObjects ?? []
        } catch {
            print("Fetch Failed! | \(error.localizedDescription)")
        }
    }
}

extension CareTaskTypeStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        types = allTypesController.fetchedObjects ?? []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            print("Updated type")
        case.delete:
            print("Deleted type")
        case .insert:
            print("Inserted type")
        case .move:
            print("Moved type")
        default:
            print("Other type")
        }
    }
}

extension CareTaskTypeStorage {
    func create(name: String) {
        let type = CareTaskTypeMO(context: context)
        type.id = UUID()
        type.name = name
        type.builtIn = false
    }
    
    func delete(_ type: CareTaskTypeMO) {
        // If built in - do not delete
        guard type.builtIn == false else { return }
        
        // Get a built in task
        let request: NSFetchRequest<CareTaskTypeMO> = CareTaskTypeMO.allBuiltInTypesRequest()
        guard let replacementType = try? context.fetch(request).first else { return }
        
        // Type cast NSSet as Set
        guard let tasks = type.tasks as? Set<CareTaskMO> else { return }
        
        // Replace current type with replacement
        for task in tasks {
            task.type = replacementType
        }
        
        // Delete current type
        context.delete(type)
    }
}
