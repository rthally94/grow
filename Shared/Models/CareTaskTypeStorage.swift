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
