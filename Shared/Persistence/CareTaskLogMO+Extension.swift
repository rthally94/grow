//
//  CareTaskLogMO+Extension.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/25/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData

extension CareTaskLogMO {
    convenience init?(careTaskLog: CareTaskLog, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = careTaskLog.id
        self.date = careTaskLog.date
    }
}
