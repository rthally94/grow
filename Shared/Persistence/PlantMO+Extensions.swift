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
        let request = NSFetchRequest<PlantMO>(entityName: "Plant")
        
        let sortByName = NSSortDescriptor(keyPath: \PlantMO.name, ascending: true)
        request.sortDescriptors = [sortByName]
        
        return request
    }
}

extension PlantMO {
    convenience init?(plant: Plant, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = plant.name
        self.isFavorite = plant.isFavorite
        self.plantingDate = plant.plantingDate
        self.careTasks = []
    }
}
