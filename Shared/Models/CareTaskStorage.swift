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

class CareTaskStorage: NSObject, ObservableObject {
    private let context: NSManagedObjectContext
    private let allTasksController: NSFetchedResultsController<CareTaskMO>
    
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    var allTasks: [CareTask] {
        return allTasksController.fetchedObjects?.compactMap( CareTask.init ) ?? []
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        allTasksController = NSFetchedResultsController(fetchRequest: CareTaskMO.allTasksFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        allTasksController.delegate = self
    }
}

extension CareTaskStorage: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
}

extension CareTaskStorage: StorageCRUD {
    func add(_ item: CareTask, to plant: Plant) {
        let plantRequest: NSFetchRequest<PlantMO> = PlantMO.fetchRequest()
        plantRequest.predicate = NSPredicate(format: "id == %@" , plant.id as CVarArg)
        
        let taskRequest: NSFetchRequest<CareTaskMO> = CareTaskMO.fetchRequest()
        taskRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        guard let plantMO = try? context.fetch(plantRequest).first else { return }
        guard let taskMO = try? context.fetch(taskRequest).first else { return }
        
        taskMO.plant = plantMO
        
        try? context.save()
    }
    
    internal func add(_ item: CareTask) {
        // Lookup care task
        let request: NSFetchRequest<CareTaskMO> = CareTaskMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        // If a task is found, return
        if let _ = try? context.fetch(request).first { return }
            
        // Create new task
        let taskMO = CareTaskMO(context: self.context)
        taskMO.id = item.id
        taskMO.notes = item.notes
        
        // TODO: Add Interval creation
        let interval = CareTaskIntervalMO(context: context)
        interval.unit = Int16(item.interval.unit.rawValue)
        interval.values = item.interval.interval as NSSet
        taskMO.interval = interval
        
        // TODO: Add Logs creation
        taskMO.logs = Set<CareTaskLogMO>(item.logs.compactMap{ CareTaskLogMO.init(careTaskLog: $0, context: context) }) as NSSet
        
        // TODO: Add Type creation
        if let itemType = item.type {
            let typeRequest: NSFetchRequest<CareTaskTypeMO> = CareTaskTypeMO.fetchRequest()
            typeRequest.predicate = NSPredicate(format: "id == %@", itemType.id as CVarArg)
            
            if let typeMO = try? context.fetch(typeRequest).first {
                // Assign existing type to task
                taskMO.type = typeMO
            } else {
                // Create a new type
                let type = CareTaskTypeMO(context: context)
                type.id = item.type?.id
                type.name = item.type?.name
                type.icon = item.type?.icon
                type.color = item.type?.color
                
                taskMO.type = type
            }
        }
    }
    
    func update(_ item: CareTask) {
        // Lookup care task
        let request: NSFetchRequest<CareTaskMO> = CareTaskMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        if let task = try? context.fetch(request).first {
            task.notes = item.notes
            
            // TODO: Add Interval update
            
            // TODO: Add Logs update
            
            // TODO: Add Type update
            
            try? context.save()
        }
    }
    
    func remove(_ item: CareTask) {
        if allTasks.contains(item), let object = allTasksController.fetchedObjects?.first(where: {$0.id == item.id}) {
            context.delete(object)
        }
    }
    
    typealias Item = CareTask
}
