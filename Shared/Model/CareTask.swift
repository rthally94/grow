//
//  CareTask.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/19/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
struct CareTask: Identifiable, Hashable, Equatable {
    let id: UUID
    var name: String
    var interval: CareInterval
    
    var notes: String
    
    var logs: [CareTaskLog]
    
    // MARK: Initializers
    
    init() {
        self.init(id: UUID(), name: "New Task", interval: .init(), notes: "", logs: [])
    }
    
    init(id: UUID, name: String, interval: CareInterval, notes: String, logs: [CareTaskLog]) {
        self.id = id
        self.name = name
        self.interval = interval
        self.notes = notes
        self.logs = logs
    }
}

// MARK: Intents
extension CareTask {
        mutating func addLog(_ log: CareTaskLog) {
            if let index = logs.firstIndex(where: { $0.id == log.id }) {
                logs[index] = log
            } else {
                logs.insert(log, at: 0)
            }
        }
    
        var latestLog: CareTaskLog? {
            return logs.first
        }
}
