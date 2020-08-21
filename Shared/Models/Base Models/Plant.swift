//
//  Plant.swift
//  GrowFramework
//
//  Created by Ryan Thally on 7/7/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData

struct Plant: Identifiable, Hashable {
    var id: UUID = UUID()
    
    // General Plant Info
    var name: String
    var plantingDate: Date?

    var isFavorite: Bool = false

    // Care Info
    var careTasks = [CareTask]()
}

extension Plant {
    init?(managedObject: PlantMO) {
        self.id = managedObject.id ?? UUID()
        self.name = managedObject.name ?? "New Plant"
        self.plantingDate = managedObject.plantingDate
        self.isFavorite = managedObject.isFavorite
//        let tasks = managedObject.careTasks as? Set<CareTaskMO> ?? []
//        self.careTasks = tasks.compactMap(CareTask.init)
    }
}

extension Plant: Equatable {
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        lhs.id == rhs.id
    }
}
