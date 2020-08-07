//
//  CareTask.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

extension CareTask {
    var id: UUID {
        get {
            if let id = id_ {
                return id
            } else {
                let id = UUID()
                id_ = id
                return id
            }
        }
    }
    
    var interval: CareTaskInterval {
        get {
            if let interval = interval_ {
                return interval
            } else {
                guard let context = managedObjectContext else { fatalError("Unable to unwrap context!") }
                let interval = CareTaskInterval.create(context: context)
                interval_ = interval
                try? context.save()
                return interval
            }
        }
        
        set {
            interval_ = newValue
        }
    }
    
    var type: CareTaskType {
        get {
            if let type = type_ {
                return type
            } else {
                guard let context = managedObjectContext else { fatalError("Unable to unwrap context!") }
                let type = CareTaskType(context: context)
                type.name = "Unknown"
                try? context.save()
                return type
            }
        }
        
        set {
            type_ = newValue
        }
    }
    
    var plants: Set<Plant> {
        get { (plants_ as? Set<Plant>) ?? []}
        set { plants_ = newValue as NSSet }
    }
    
    var notes: String {
        get { notes_ ?? "" }
        set { notes_ = newValue }
    }
    
    var logs: Set<CareTaskLog> {
        get { logs_ as? Set<CareTaskLog> ?? [] }
        set { logs_ = newValue as NSSet }
    }
}

extension CareTask: Comparable {
    public static func < (lhs: CareTask, rhs: CareTask) -> Bool {
        lhs.type < rhs.type
    }
}

//struct CareTaskType: Identifiable, Hashable, Equatable {
//    let id: UUID
//    var name: String
//    var icon: String?
//    var color: String?
//}

//extension CareTaskType {
//    static let WateringType = CareTaskType(id: UUID(), name: "Watering", color: "")
//    static let PruningType = CareTaskType(id: UUID(), name: "Pruning")
//    static let FertilizingType = CareTaskType(id: UUID(), name: "Pruning")
//}


//struct CareTask: Identifiable, Hashable, Equatable {
//    let id: UUID
//
//    var associatedTask: CareTaskType.ID
//    var interval: CareInterval
//
//    var notes: String
//
//    var logs: [CareTaskLog]
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
//    // MARK: Initializers
//
//    init() {
//        self.init(id: UUID(), type: CareTaskType.ID, interval: .init(), notes: "", logs: [])
//    }
//
//    init(id: UUID, type: CareTaskType.ID, interval: CareInterval, notes: String, logs: [CareTaskLog]) {
//        self.id = id
//        self.associatedTask = type
//        self.interval = interval
//        self.notes = notes
//        self.logs = logs
//    }
//}
//
//// MARK: Intents
//extension CareTask {
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
