//
//  CareTaskMO+Extensions.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension CareTask {
    enum IntervalUnit: Int64, CaseIterable, CustomStringConvertible {
        case never, daily, weekly, monthly
        
        var description: String {
            let returnString: String
            
            switch self {
            case .never: returnString = "never"
            case .daily: returnString = "daily"
            case .weekly: returnString = "weekly"
            case .monthly: returnString = "monthly"
            }
            
            return returnString
        }
    }
}

// MARK: Static Functions
extension CareTask {
    // Fetch Requests
    
    /// Creates a fetch request for getting all tasks, sorted by type
    /// - Returns: The fetch request
    static func allTasksFetchRequest() -> NSFetchRequest<CareTask> {
        let request: NSFetchRequest<CareTask> = CareTask.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \CareTask.type_, ascending: true) ]
        return request
    }
    
    /// Creates a fetch request for getting all tasks for a specified plant, sorted by type
    /// - Returns: The fetch request
    static func allTasksFetchRequest(for plant: Plant) -> NSFetchRequest<CareTask> {
        let request: NSFetchRequest<CareTask> = CareTask.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \CareTask.type_, ascending: true) ]
        request.predicate = NSPredicate(format: "plant == %@", plant)
        return request
    }
    
    // Intents
    
    /// Creates a new care task in the sepcified context
    /// - Parameter context: The ManagedObjectContext to create the task in
    @discardableResult static func create(in context: NSManagedObjectContext) -> CareTask {
        let newTask = CareTask(context: context)
        newTask.interval = (.never, [])
        
        try? context.save()
        return newTask
    }
}

// MARK: Deletion Intent
extension Collection where Element == CareTask, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach { managedObjectContext.delete(self[$0])}
        try? managedObjectContext.save()
    }
}

// MARK: Unwrappers
extension CareTask {
    var note: String {
        get { note_ ?? "" }
        set { note_ = newValue }
    }
    
    var type: CareTaskType {
        get {
            if let type = type_ { return type }
            else {
                guard let context = managedObjectContext else { fatalError("Cannot fetch default task type. Care Task not linked to a managed object context.") }
                if let type = try? context.fetch(CareTaskType.allBuiltInTypesRequest()).first {
                    return type
                } else {
                    let type = CareTaskType(context: context)
                    type.builtIn = true
                    type.name = "General"
                    type.color = UIColor.systemBlue
                    type.icon = "doc.fill"
                    
                    type_ = type
                    return type
                }
            }
        }
        
        set { type_ = newValue }
    }
    
    var intervalUnit: IntervalUnit {
        get { IntervalUnit(rawValue: intervalUnit_) ?? .never }
        set { intervalUnit_ = newValue.rawValue }
    }
    
    var intervalValues: Set<Int> {
        get { intervalValues_ as? Set<Int> ?? [] }
        set { intervalValues_ = newValue as NSSet }
    }
    
    var interval: (IntervalUnit, Set<Int>) {
        get { (intervalUnit, intervalValues) }
        set {
            intervalUnit = newValue.0
            intervalValues = newValue.1
        }
    }
    
    var logs: [CareTaskLogMO] {
        get { logs_?.array as? [CareTaskLogMO] ?? [] }
        set { logs_ = NSOrderedSet(array: newValue) }
    }
    
    var nextCareDate: Date {
        func nextCareDate(for date: Date) -> Date {
            switch intervalUnit {
            case .never:
                return Date()
                
            case .daily:
                return Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date()
                
            case .weekly:
                let lastCompletedWeekday = Calendar.current.component(.weekday, from: date)
                let weekdays = intervalValues.sorted()
                let nextWeekday = weekdays.first(where: { $0 > lastCompletedWeekday }) ?? weekdays[0]
                
                return Calendar.current.nextDate(after: date, matching: .init(weekday: nextWeekday), matchingPolicy: .nextTime) ?? Date()
                
            case .monthly:
                let day = intervalValues.first ?? Calendar.current.component(.day, from: date)
                return Calendar.current.nextDate(after: date, matching: .init(day: day), matchingPolicy: .previousTimePreservingSmallerComponents) ?? Date()
            }
        }
        
        if let lastLog = logs.first {
            // Has a log. Use its date as the reference point
            return Calendar.current.startOfDay(for: nextCareDate(for: lastLog.date))
        } else {
            // Has not been logged. Use next possible date matching interval
            return Calendar.current.startOfDay(for: nextCareDate(for: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()))
        }
    }
}
