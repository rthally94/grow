//
//  CareTask.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

struct CareTaskType: Equatable, Hashable {
    var name: String
    var icon: String?
    var color: String?
}

extension CareTaskType {
    init?(managedObject: CareTaskTypeMO) {
        let name = managedObject.name ?? "New Task"
        self.init(name: name, icon: managedObject.icon, color: managedObject.color)
    }
}

extension CareTaskType {
    static let WateringType = CareTaskType(name: "Watering", color: "")
    static let PruningType = CareTaskType(name: "Pruning")
    static let FertilizingType = CareTaskType(name: "Pruning")
}


struct CareTask: Equatable, Hashable {
    var type: CareTaskType?
    var interval: CareInterval

    var notes: String

    var logs: [CareTaskLog]
}

extension CareTask {
    init?(managedObject: CareTaskMO) {
        guard let interval = managedObject.interval else { return nil }
        self.interval = CareInterval(managedObject: interval) ?? CareInterval()
        
        guard let type = managedObject.type else { return nil }
        self.type = CareTaskType(managedObject: type)
        
        let logs = managedObject.logs as? Set<CareTaskLogMO> ?? []
        self.logs = logs.compactMap(CareTaskLog.init)
        
        self.notes = managedObject.notes ?? ""
    }
}

extension CareTask: Comparable {
    static func < (lhs: CareTask, rhs: CareTask) -> Bool {
        lhs.hashValue < rhs.hashValue
    }
}

//// MARK: Intents
//extension CareTask {
//
//    var needsCare: Bool {
//        // If task does not have an interval, care reminder is not required
//        if interval.unit == .never { return false }
//
//        // A log is required to calculate next event, If no logs if present a reminder is required
//        guard let lastLog = logs.first else { return true }
//        let next = interval.next(from: lastLog.date)
//
//        // Check if next is <= today
//        return Calendar.current.compare(next, to: Date(), toGranularity: .day) != .orderedDescending
//    }
//
//        mutating func addLog(_ log: CareTaskLog) {
//            if let index = logs.firstIndex(where: { $0.id == log.id }) {
//                logs[index] = log
//            } else {
//                logs.insert(log, at: 0)
//            }
//        }
//
//        var latestLog: CareTaskLog? {
//            return logs.first
//        }
//}
