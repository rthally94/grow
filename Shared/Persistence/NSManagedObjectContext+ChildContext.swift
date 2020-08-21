//
//  ChildContext.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/12/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

extension NSManagedObjectContext {
    var childContext: NSManagedObjectContext {
        let child = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        child.parent = self
        return child
    }
}
