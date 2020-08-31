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
    
    @Published var allTypes = [CareTaskTypeMO]()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        allTypesController = NSFetchedResultsController(fetchRequest: CareTaskTypeMO.allTypesFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "builtIn", cacheName: nil)
        
        super.init()
        
        allTypesController.delegate = self
        
        do {
            try allTypesController.performFetch()
            allTypes = allTypesController.fetchedObjects ?? []
        } catch {
            print("Fetch Failed! | \(error.localizedDescription)")
        }
    }
}

extension CareTaskTypeStorage: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        allTypes = allTypesController.fetchedObjects ?? []
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
