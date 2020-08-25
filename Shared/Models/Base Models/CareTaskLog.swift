//
//  CareActivity.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/10/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

struct CareTaskLog: Identifiable, Equatable, Hashable {
    var id = UUID()
    var date: Date
    var note: String
}

extension CareTaskLog {
    init?(managedObject: CareTaskLogMO) {
        self.id = managedObject.id ?? UUID()
        self.date = managedObject.date ?? Date()
        self.note = ""
    }
}
