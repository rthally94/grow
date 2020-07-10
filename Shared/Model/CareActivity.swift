//
//  CareActivity.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/10/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

struct CareActivity: Identifiable, Hashable {
    enum CareType {
        case water, prune, fertilize
        
        var description: String {
            switch self {
            case .water: return "Watering"
            case .prune: return "Pruning"
            case .fertilize: return "Fertilizing"
            }
        }
    }
    
    var id: UUID
    var type: CareType
    var date: Date
    
    
    init() {
        self.init(id: UUID(), type: .water, date: Date())
    }
    
    init(type: CareType, date: Date) {
        self.init(id: UUID(), type: type, date: date)
    }
    
    init(id: UUID, type: CareType, date: Date) {
        self.id = id
        self.type = type
        self.date = date
    }
}
