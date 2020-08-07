//
//  CareTaskType+CoreDataProperties.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/6/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit.UIImage
import UIKit.UIColor

extension CareTaskType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CareTaskType> {
        return NSFetchRequest<CareTaskType>(entityName: "CareTaskType")
    }

    @NSManaged public var color: UIColor?
    @NSManaged public var icon: UIImage?
    @NSManaged public var id: UUID?
    @NSManaged public var name_: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension CareTaskType {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: CareTask)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: CareTask)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
