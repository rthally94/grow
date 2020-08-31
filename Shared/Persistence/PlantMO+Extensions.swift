//
//  PlantMO+Extensions.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData

extension PlantMO {
    static func allPlantsFetchRequest() -> NSFetchRequest<PlantMO> {
        let request: NSFetchRequest<PlantMO> = PlantMO.fetchRequest()
        let sortByName = NSSortDescriptor(keyPath: \PlantMO.name_, ascending: true)
        request.sortDescriptors = [sortByName]
        
        return request
    }
}

extension PlantMO: Identifiable { }

extension PlantMO {
    public var id: UUID {
        if let id = id_ {
            return id
        } else {
            let id = UUID()
            id_ = id
            return id
        }
    }
    
    var name: String {
        get {
            name_ ?? ""
        }
        
        set {
            name_ = newValue
        }
    }
    
    var careTasks: Set<CareTaskMO> {
        get {
            careTasks_ as? Set<CareTaskMO> ?? []
        }
        
        set {
            careTasks_ = newValue as NSSet
        }
    }
}
