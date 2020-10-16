//
//  Persistence.swift
//  Persistence
//
//  Created by Ryan Thally on 9/7/20.
//

import CoreData
import UIKit

struct PersistenceController {
    static func getDefaultController(inMemory: Bool = false) -> PersistenceController {
        let controller = PersistenceController(inMemory: inMemory)
        let viewContext = controller.container.viewContext
        
        // Add default task types
        let _: CareTaskType = {
            let type = CareTaskType(context: viewContext)
            type.name = "Watering"
            type.color = UIColor.systemBlue
            type.icon = "drop.fill"
            type.builtIn = true
            return type
        }()
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }
    
    static let shared = getDefaultController()

    static var preview: PersistenceController = {
        let result = getDefaultController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let request: NSFetchRequest<CareTaskType> = CareTaskType.allBuiltInTypesRequest()
        request.fetchLimit = 1
        
        let type = try? viewContext.fetch(request).first
        
        for index in 0..<10 {
            let newItem = Plant(context: viewContext)
            newItem.name = "Plant \(index)"
            
            newItem.careTasks.insert( {
                    let task = CareTask(context: viewContext)
                    task.type_ = type
                    task.interval = (.never, [])
                    
                    return task
                }()
            )
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static var previewPlant: Plant {
        let viewContext = PersistenceController.preview.container.viewContext
        
        let request = Plant.allPlantsFetchRequest()
        request.fetchLimit = 1
        
        guard let plant = try? viewContext.fetch(request).first else {
            fatalError("No plant available in preview context.")
        }
        
        return plant
    }
    
    

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Grow")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
