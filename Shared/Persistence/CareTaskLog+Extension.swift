//
//  CareTaskLog+Extension.swift
//  Grow iOS
//
//  Created by Ryan Thally on 9/5/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData

extension CareTaskLog {
    static func fetchLogs(for task: CareTask, limit: Int? = nil ) -> NSFetchRequest<CareTaskLog> {
        let request: NSFetchRequest<CareTaskLog> = CareTaskLog.fetchRequest()
        request.sortDescriptors = [
            // Sort by date
            NSSortDescriptor(keyPath: \CareTaskLog.date_, ascending: false)
        ]
        
        request.predicate = NSPredicate(format: "task == %@", task)
        
        if let limit = limit, limit > 0 {
            request.fetchLimit = limit
        }
        
        return request
    }
}

extension CareTaskLog {
    static func create(for task: CareTask, in context: NSManagedObjectContext) -> CareTaskLog {
        let log = CareTaskLog(context: context)
        log.task = task
        
        try? context.save()
        
        return log
    }
}

extension CareTaskLog {
    var date: Date {
        get { date_ ?? Date() }
        set { date_ = newValue }
    }
}
