//
//  CareTaskStorage.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/27/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import Combine
import CoreData

class CareTaskStorage: NSObject, ObservableObject {
    private let context: NSManagedObjectContext
    private let tasksNeedingCareController: NSFetchedResultsController<CareTaskMO>
    
    @Published private(set) var tasks = [CareTaskMO]()
    
    func tasksNeedingCare(on date: Date) -> [CareTaskMO] {
        return []
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.tasksNeedingCareController = NSFetchedResultsController<CareTaskMO>(fetchRequest: CareTaskMO.taskFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "type_", cacheName: nil)
        
        super.init()
        
        tasksNeedingCareController.delegate = self
        
        do {
            try tasksNeedingCareController.performFetch()
            tasks = tasksNeedingCareController.fetchedObjects ?? []
        } catch {
            print("Fetch Failed! | \(error.localizedDescription)")
        }
    }
}

extension CareTaskStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasks = tasksNeedingCareController.fetchedObjects ?? []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            print("Updated task")
        case.delete:
            print("Deleted task")
        case .insert:
            print("Inserted task")
        case .move:
            print("Moved task")
        default:
            print("Other task")
        }
    }
}

extension CareTaskStorage {
    func getTasksForToday() {
        tasksNeedingCareController.fetchRequest.predicate = CareTaskMO.tasksNeedingCareTodayPredicate()
        try! tasksNeedingCareController.performFetch()
    }
    
    func getTasks(for date: Date) {
        tasksNeedingCareController.fetchRequest.predicate = CareTaskMO.tasksNeedingCarePrediate(on: date)
        try! tasksNeedingCareController.performFetch()
    }
}
