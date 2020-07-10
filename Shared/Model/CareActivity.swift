//
//  CareActivity.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/10/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

protocol CareActivity: Identifiable, Hashable {
    var id: UUID { get set }
    var date: Date { get set }
    
    init()
    init(date: Date)
    init(id: UUID, date: Date)
}

struct WaterActivity: CareActivity {
    var id: UUID
    var date: Date
    
    init() {
        self.init(id: UUID(), date: Date())
    }
    
    init(date: Date) {
        self.init(id: UUID(), date: date)
    }
    
    init(id: UUID, date: Date) {
        self.id = id
        self.date = date
    }
}
