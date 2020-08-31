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
    convenience init?(task: CareTask, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = task.id
        self.notes = task.notes
    }
}
