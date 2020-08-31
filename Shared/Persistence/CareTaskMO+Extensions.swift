//
//  CareTaskMO+Extensions.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData

extension CareTaskMO {
    
    /// Creates a predicate for filtering tasks that require care today. Includes tasks that have outstanding care needs.
    /// - Returns: The predicate for filtering
    static func tasksNeedingCareTodayPredicate() -> NSPredicate {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
        
        return NSPredicate(format: "ANY logs_.date <= %@ ", endOfDay as NSDate)
    }
    
    /// Creates a predicate for filtering tasks that require care on a specified date.
    /// - Parameter date: The desired date for care
    /// - Returns: The predicate for filtering
    static func tasksNeedingCarePrediate(on date: Date) -> NSPredicate {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
        let lowerBound = NSPredicate(format: "ANY logs_.date >= %@", startOfDay as NSDate)
        let upperBound = NSPredicate(format: "ANY logs_.date < %@", endOfDay as NSDate)
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [lowerBound, upperBound])
    }
    
    static func taskFetchRequest() -> NSFetchRequest<CareTaskMO> {
        let request: NSFetchRequest<CareTaskMO> = CareTaskMO.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \CareTaskMO.type_, ascending: true) ]
        return request
    }
}

extension CareTaskMO {
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
    
    var note: String {
        get { note_ ?? "" }
        set { note_ = newValue }
    }
    
    var type: CareTaskTypeMO {
        get {
            if let type = type_ { return type }
            else {
                guard let context = managedObjectContext else { fatalError("Cannot fetch default task type. Care Task not linked to a managed object context.") }
                if let type = try? context.fetch(CareTaskTypeMO.allBuiltInTypesRequest()).first {
                    return type
                } else {
                    let type = CareTaskTypeMO(context: context)
                    type.id = UUID()
                    type.builtIn = true
                    type.name = "General"
                    type.color = "systemBlue"
                    type.icon = "doc.fill"
                    
                    type_ = type
                    return type
                }
            }
        }
        
        set { type_ = newValue }
    }
    
    var interval: CareTaskIntervalMO {
        get {
            if let interval = interval_ { return interval }
            else {
                guard let context = managedObjectContext else { fatalError("Cannot fetch default interval. Care Task not linked to a managed object context.") }
                let interval = CareTaskIntervalMO(context: context)
                interval.unit = .never
                interval.values = []
                
                interval_ = interval
                return interval
            }
        }
        
        set { interval_ = newValue }
    }
}
