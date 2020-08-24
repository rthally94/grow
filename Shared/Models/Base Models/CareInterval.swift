//
//  CareInterval.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/16/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData

struct CareInterval: Equatable, CustomStringConvertible, Hashable {
    enum Unit: Int, CaseIterable, CustomStringConvertible, Hashable {
        case daily
        case weekly
        case monthly
        case never

        var description: String {
            switch self {
            case .never: return "never"
            case .daily: return "daily"
            case .weekly: return "weekly"
            case .monthly: return "monthly"
            }
        }
    }

    var unit: Unit
    var interval: Set<Int> = [0]

    // MARK: Initializers

    /// Initializer - Creates an instance using all parameters
    /// - Parameters:
    ///   - unit: The desired unit for the interval
    ///   - interval: The associated value for the interval
    init(unit: Unit, interval: Set<Int>) {
        switch unit {
        case .never:
            self.unit = unit
            self.interval = []

        case .daily:
            self.unit = unit
            self.interval = [interval.first ?? 1]

        default:
            self.unit = unit
            self.interval = interval
        }
    }

    /// Initializer - Creates an instance with no interval
    init() {
        self.init(unit: .never, interval: [])
    }

    /// Initializer - Creates an instance for a weekly repeat interval on the desired weekday ordinal
    /// - Parameter weekdayOrdinal: The desired weekday ordinal based on the user's current calendar locale
    init(weekdayOrdinal: Int) {
        self.init(unit: .weekly, interval: [weekdayOrdinal])
    }

    /// Initializer - Creates an instance for a weekly repeat interval on the desired weekday ordinal
    /// - Parameter weekdayOrdinals: The desired weekday ordinals based on the user's current calendar locale
    init(weekdayOrdinals: Set<Int>) {
        self.init(unit: .weekly, interval: weekdayOrdinals)
    }

    /// Initializer - Creates an instance for a monthly repeat interval on a specific day of the month
    /// - Parameter dayOfMonth: The desired day of the month to repeat on
    init(dayOfMonth: Int) {
        self.init(unit: .monthly, interval: [dayOfMonth])
    }

    /// A user friendly description of the current interval
    var description: String {
        switch unit {
        case .never: fallthrough
        case .daily: return unit.description.capitalized
        case .weekly:
            let daysOfWeek = interval.sorted().compactMap { interval.count > 1 ? Formatters.shortDayOfWeek(for: $0) : Formatters.fullDayOfWeek(for: $0) }
            guard let combinedDaysOfWeek = Formatters.listFormatter.string(from: daysOfWeek) else { return unit.description }
            return "\(unit.description.capitalized) on \(combinedDaysOfWeek)"
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
        case .never: return Date()
        case .daily:
            let next = cal.date(byAdding: .day, value: interval.first ?? 1, to: date) ?? date
            return cal.startOfDay(for: next)

        case .weekly:
            let first = interval.min() ?? 0
            let today = cal.component(.weekdayOrdinal, from: Date())
            let nextOrdinal = interval.first(where: { $0 > today}) ?? first

            let next = cal.nextDate(after: date, matching: .init(weekdayOrdinal: nextOrdinal), matchingPolicy: .nextTime) ?? date
            return cal.startOfDay(for: next)

        case .monthly:
            let next = cal.nextDate(after: date, matching: .init(day: interval.first ?? 1), matchingPolicy: .previousTimePreservingSmallerComponents) ?? date
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
        case (.never, let value): return value == 0
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

extension CareInterval {
    init?(managedObject: CareTaskIntervalMO) {
        let unit = CareInterval.Unit(rawValue: Int(managedObject.unit)) ?? .never
        let interval = managedObject.values as? Set<Int> ?? []
        
        self.init(unit: unit, interval: interval)
    }
}