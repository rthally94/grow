//
//  Plant.swift
//  GrowFramework
//
//  Created by Ryan Thally on 7/7/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

struct Plant: Identifiable, Hashable, Equatable {
    // General Plant Info
    let id: UUID
    var name: String
    var pottingDate: Date?
    
    var isFavorite: Bool = false
    
    // Care Info
    var careTasks: [CareTask]
    var tasksNeedingCare: [CareTask] {
        careTasks.filter { $0.needsCare }
    }
    
    // Care Activity
//    private(set) var careActivity = [CareTaskLog]()
    
    // MARK: Initializers
    init() {
        self.init(id: UUID(), name: "My Plant", pottingDate: nil, careTasks: [])
    }
    
    init(name: String) {
        self.init(id: UUID(), name: name, pottingDate: nil, careTasks: [])
    }
    
    init(id: UUID, name: String, pottingDate: Date?, careTasks: [CareTask]) {
        self.id = id
        self.name = name
        self.pottingDate = pottingDate
        self.careTasks = careTasks
    }
}

extension Plant {
    var age: TimeInterval {
        return DateInterval(start: pottingDate ?? Date(), end: Date()).duration
    }
}

// MARK: Plant Intents
extension Plant {
    mutating func addCareTask(_ task: CareTask) {
        if let index = careTasks.firstIndex(where: { $0.id == task.id }) {
            careTasks[index] = task
        } else {
            careTasks.append(task)
        }
    }
    
    mutating func removeCareTask(_ task: CareTask) {
        if let index = careTasks.firstIndex(of: task) {
            careTasks.remove(at: index)
        }
    }
}
