//
//  CareActivity.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/10/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

struct CareTaskLog: Equatable, Hashable {
    var date: Date
    var note: String
}

extension CareTaskLog {
    init?(managedObject: CareTaskLogMO) {
        self.date = managedObject.date ?? Date()
        self.note = ""
    }
}
