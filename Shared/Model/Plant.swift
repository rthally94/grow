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
    
    // Care Info
    var sunTolerance: SunTolerance
    var wateringInterval: CareInterval
    
    var age: TimeInterval {
        return DateInterval(start: pottingDate ?? Date(), end: Date()).duration
    }
    
    // Care Activity
    private(set) var careActivity = [CareActivity]()
    
    // MARK: Initializers
    init() {
        self.init(id: UUID(), name: "My Plant", pottingDate: nil, sunTolerance: .fullShade, wateringInterval: CareInterval())
    }
    
    init(name: String) {
        self.init(id: UUID(), name: name, pottingDate: nil, sunTolerance: .fullShade, wateringInterval: CareInterval())
    }
    
    init(id: UUID, name: String, pottingDate: Date?, sunTolerance: SunTolerance, wateringInterval: CareInterval) {
        self.id = id
        self.name = name
        self.pottingDate = pottingDate
        self.sunTolerance = sunTolerance
        self.wateringInterval = wateringInterval
    }
}

// MARK: Plant Intents
extension Plant {
    mutating func addCareActivity(_ log: CareActivity) {
        careActivity.insert(log, at: 0)
    }
    
    var latestWaterActivity: CareActivity? {
        return getWaterActivity().first
    }
    
    func getWaterActivity(max: Int = 1) -> [CareActivity] {
        return getActivity(for: .water, max: max)
    }
    
    func getActivity(for type: CareActivity.CareType? = nil, max: Int = 1) -> [CareActivity] {
        var logs = [CareActivity]()
        
        if let logType = type {
            for activity in careActivity where activity.type == logType {
                logs.append(activity)
                if logs.count == max { break }
            }
        } else {
            for activity in careActivity {
                logs.append(activity)
                if logs.count == max { break }
            }
        }
        
        return logs
    }
}
