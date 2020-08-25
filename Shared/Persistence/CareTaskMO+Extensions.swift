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
    static func allTasksFetchRequest() -> NSFetchRequest<CareTaskMO> {
        let request: NSFetchRequest<CareTaskMO> = CareTaskMO.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \CareTaskMO.type, ascending: true) ]
        return request
    }
}
