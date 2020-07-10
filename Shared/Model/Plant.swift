//
//  Plant.swift
//  GrowFramework
//
//  Created by Ryan Thally on 7/7/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

struct Plant: Identifiable, Hashable {
    // General Plant Info
    var id: UUID
    var name: String
    var pottingDate: Date?
    
    // Care Info
    var wateringInterval: CareInterval?
    
    var age: TimeInterval {
        return DateInterval(start: pottingDate ?? Date(), end: Date()).duration
    }
    
    // Care Activity
    private(set) var careActivity = [CareActivity]()
}

// MARK: Plant Intents
extension Plant {
    mutating func addCareActivity(_ log: CareActivity) {
        careActivity.insert(log, at: 0)
    }
    
    var lastWaterLog: CareActivity? {
        return getWaterLogs().first
    }
    
    func getWaterLogs(max: Int = 1) -> [CareActivity] {
        return getLogs(type: .water, max: max)
    }
    
    func getLogs(type: CareActivity.CareType? = nil, max: Int = 1) -> [CareActivity] {
        var logs = [CareActivity]()
        
        if let logType = type {
            for activity in careActivity where activity.type == logType {
                logs.append(activity)
                if logs.count == max { break }
            }
        } else {
            for activity in careActivity {
                logs.append(activity)
                if logs.count == max { break }
            }
        }
        
        return logs
    }
}

struct CareInterval: Hashable, CustomStringConvertible {
    enum Unit {
        case daily, weekly, monthly
        
        var description: String {
            switch self {
            case .daily: return "daily"
            case .weekly: return "weekly"
            case .monthly: return "monthly"
            }
        }
    }
    
    let unit: Unit
    
    private var _interval: Int = 0
    var interval: Int {
        get {
            return max(_interval, 0)
        }
        
        set {
            _interval = newValue
        }
    }
    
    // MARK: Initializers
    
    /// Initializer - Creates an instance using all parameters
    /// - Parameters:
    ///   - unit: The desired unit for the interval
    ///   - interval: The associated value for the interval
    init(unit: Unit, interval: Int) {
        self.unit = unit
        self.interval = interval
    }
    
    /// Initializer - Creates an instance for a daily repeat interval
    init() {
        self.init(unit: .daily, interval: 1)
    }
    
    /// Initializer - Creates an instance for a weekly repeat interval on the desired weekday ordinal
    /// - Parameter weekdayOrdinal: The desired weekday ordinal based on the user's current calendar locale
    init(weekdayOrdinal: Int) {
        self.init(unit: .weekly, interval: weekdayOrdinal)
    }
    
    /// Initializer - Creates an instance for a monthly repeat interval on a specific day of the month
    /// - Parameter dayOfMonth: The desired day of the month to repeat on
    init(dayOfMonth: Int) {
        self.init(unit: .monthly, interval: dayOfMonth)
    }
    
    /// A user friendly description of the current interval
    var description: String {
        switch unit {
        case .daily: return unit.description
        case .weekly:
            guard let dayOfWeek = Formatters.fullDayOfWeek(for: interval) else { return unit.description }
            return "\(unit.description) on \(dayOfWeek)"
        case .monthly:
            guard let dayOfMonth = Formatters.ordinalNumberFormatter.string(for: interval) else { return unit.description }
            return "on the \(dayOfMonth)"
        }
    }
    
    /// Returns the next calendar date in which satisifies the current interval parameters
    /// - Parameter date: The desired reference date - defaults to now.
    /// - Returns: The next date the that satisifies the interval parameters
    func next(from date: Date = Date()) -> Date {
        let cal = Calendar.current
        
        switch unit {
        case .daily:
            let next = cal.date(byAdding: .day, value: interval, to: date) ?? date
            return cal.startOfDay(for: next)
            
        case .weekly:
            let next = cal.nextDate(after: date, matching: .init(weekdayOrdinal: interval), matchingPolicy: .nextTime) ?? date
            return cal.startOfDay(for: next)
            
        case .monthly:
            let next = cal.nextDate(after: date, matching: .init(day: interval), matchingPolicy: .previousTimePreservingSmallerComponents) ?? date
            return cal.startOfDay(for: next)
        }
    }
    
    /// Veryifies a given interval and unit combination will result in a correct date offset
    /// - Parameters:
    ///   - interval: The desired interval
    ///   - unit: The desired unit
    /// - Returns: True if the interval/unit combination is valid, False otherwise
    static func isValid(interval: Int, for unit: Unit) -> Bool {
        let cal = Calendar.current
        
        switch (unit, interval) {
        case (.daily, _): return true
        case (.weekly, let value) where 0 <= value && value < cal.weekdaySymbols.count: return true
        case (.monthly, let value):
            guard let date = cal.date(bySetting: .day, value: value, of: Date()) else { return false }
            for month in 0..<cal.monthSymbols.count {
                if let _ = cal.date(bySetting: .month, value: month, of: date) {
                    return true
                }
            }
            return false
            
        default:
            return false
        }
    }
}
