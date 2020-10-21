//
//  Plant+Extensions.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// MARK: Static Functions
extension Plant {
    // Fetch Requests
    static func allPlantsFetchRequest() -> NSFetchRequest<Plant> {
        let request: NSFetchRequest<Plant> = Plant.fetchRequest()
        let sortByName = NSSortDescriptor(keyPath: \Plant.name_, ascending: true)
        request.sortDescriptors = [sortByName]
        
        return request
    }
    
    // Intents
    @discardableResult static func create(in context: NSManagedObjectContext) -> Plant {
        let newPlant = self.init(context: context)
        
        let request = CareTaskType.allBuiltInTypesRequest()
        
        let typePredicate = NSPredicate(format: "name_ == %@", "Watering")
        if let oldPredicate = request.predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [oldPredicate, typePredicate])
        } else {
            request.predicate = typePredicate
        }
        
        let taskType = try? context.fetch(request).first
        
        let task = CareTask.create(in: context)
        task.type_ = taskType
        task.plant = newPlant
        
        try? context.save()
        return newPlant
    }
}

// MARK: Deletion Intent
extension Collection where Element == Plant, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach { managedObjectContext.delete(self[$0]) }
        try? managedObjectContext.save()
    }
}

// MARK: Unwrappers
extension Plant {
    var name: String {
        get {
            name_ ?? ""
        }
        
        set {
            name_ = newValue
        }
    }
    
    var careTasks: Set<CareTask> {
        get {
            careTasks_ as? Set<CareTask> ?? []
        }
        
        set {
            careTasks_ = newValue as NSSet
        }
    }
    
    var tintColor: UIColor {
        get {
            guard let hex = tintColor_, let color = UIColor(hexString: hex) else { return UIColor.systemBlue }
            return color
        }
        
        set {
            tintColor_ = newValue.hexString()
        }
    }
    
    var icon: UIImage? {
        get {
            guard let iconName = icon_ else { return nil }
            
            return UIImage(named: iconName)
        }
    }
}

