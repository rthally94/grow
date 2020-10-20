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
    
    var logs: [CareTaskLog] {
        get { logs_?.array as? [CareTaskLog] ?? [] }
        set { logs_ = NSOrderedSet(array: newValue) }
    }
    
    var latestLog: CareTaskLog? {
        logs.max(by: { $0.date > $1.date })
    }
    
    func nextCareDate(for date: Date) -> Date? {
        let nextTaskDate: Date?
        
        switch(intervalUnit, latestLog) {
        case (.daily, nil):
            nextTaskDate = date
        case (.daily, .some):
            nextTaskDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
            
        case (.weekly, nil):
            let weekday = Calendar.current.component(.weekday, from: date)
            
            let weekdays = intervalValues.sorted()
            
            if weekdays.contains(weekday) {
                nextTaskDate =  date
            } else {
                let nextWeekday = weekdays.first(where: { $0 > weekday }) ?? weekdays[0]
                nextTaskDate = Calendar.current.nextDate(after: date, matching: .init(weekday: nextWeekday), matchingPolicy: .nextTimePreservingSmallerComponents)
            }
        case (.weekly, let log):
            let weekday = Calendar.current.component(.weekday, from: log!.date)
            
            let weekdays = intervalValues.sorted()
            
            let nextWeekday = weekdays.first(where: { $0 > weekday }) ?? weekdays[0]
            nextTaskDate = Calendar.current.nextDate(after: date, matching: .init(weekday: nextWeekday), matchingPolicy: .nextTimePreservingSmallerComponents)
            
        case (.monthly, nil):
            let lastCompletedDay = Calendar.current.component(.day, from: date)
            let days = intervalValues.sorted()
            
            if days.contains(lastCompletedDay) {
                nextTaskDate = date
            } else {
                let nextDay = days.first(where: { $0 > lastCompletedDay }) ?? days[0]
                nextTaskDate = Calendar.current.nextDate(after: date, matching: .init(day: nextDay), matchingPolicy: .previousTimePreservingSmallerComponents)
            }
        case (.monthly, let log):
            let lastCompletedDay = Calendar.current.component(.day, from: log!.date)
            let days = intervalValues.sorted()
                
            let nextDay = days.first(where: { $0 > lastCompletedDay }) ?? days[0]
            nextTaskDate = Calendar.current.nextDate(after: date, matching: .init(day: nextDay), matchingPolicy: .previousTimePreservingSmallerComponents)
            
        default:
            nextTaskDate = nil
        }
        
        if let next = nextTaskDate {
            return Calendar.current.startOfDay(for: next)
        } else {
            return nextTaskDate
        }
    }
    
    //    func nextCareDate() -> Date? {
    
    //        func nextCareDate(for date: Date) -> Date? {
    //            switch intervalUnit {
    //            case .daily:
    //                return Calendar.current.date(byAdding: .day, value: 1, to: date)
    //
    //            case .weekly:
    //                let lastCompletedWeekday = Calendar.current.component(.weekday, from: date)
    //                let weekdays = intervalValues.sorted()
    //
    //                if weekdays.contains(lastCompletedWeekday) {
    //                    return date
    //                } else {
    //                    let nextWeekday = weekdays.first(where: { $0 > lastCompletedWeekday }) ?? weekdays[0]
    //                    return Calendar.current.nextDate(after: date, matching: .init(weekday: nextWeekday), matchingPolicy: .nextTime)
    //                }
    //
    //            case .monthly:
    //                let lastCompletedDay = Calendar.current.component(.day, from: date)
    //                let days = intervalValues.sorted()
    //
    //                if days.contains(lastCompletedDay) {
    //                    return date
    //                } else {
    //                    let nextDay = days.first(where: { $0 > lastCompletedDay }) ?? days[0]
    //                    return Calendar.current.nextDate(after: date, matching: .init(day: nextDay), matchingPolicy: .previousTimePreservingSmallerComponents)
    //                }
    //
    //            default:
    //                return nil
    //            }
    //        }
    //
    //        if let lastLog = latestLog {
    //            // Has a log. Use its date as the reference point
    //            if let next = nextCareDate(for: lastLog.date) {
    //                return Calendar.current.startOfDay(for: next)
    //            } else {
    //                return nil
    //            }
    //        } else {
    //            // Has not been logged. Use next possible date matching interval
    //            if let next = nextCareDate(for: Calendar.current.date(byAdding: .day, value: -1, to: Date())) {
    //                return Calendar.current.startOfDay(for: next)
    //            } else {
    //                return nil
    //            }
    //        }
    
    //        if let next = nextCareDate(for: latestLog.date) {
    //            return Calendar.current.startOfDay(for: next)
    //        } else {
    //            return nil
    //        }
    //    }
}
