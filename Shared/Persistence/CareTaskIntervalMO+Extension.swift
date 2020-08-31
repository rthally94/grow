//
//  CareTaskIntervalMO+Extension.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/26/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

extension CareTaskIntervalMO {
    enum Unit: Int16, CaseIterable, CustomStringConvertible {
        case never, daily, weekly, monthly
        
        var description: String {
            let returnString: String
            
            switch self {
            case .never: returnString = "Never"
            case .daily: returnString = "daily"
            case .weekly: returnString = "weekly"
            case .monthly: returnString = "monthly"
            }
            
            return returnString
        }
    }
    
    var unit: Unit {
        get { Unit(rawValue: unit_) ?? .never }
        set { unit_ = newValue.rawValue as Int16}
    }
    
    var values: Set<Int> {
        get { values_ as? Set<Int> ?? [] }
        set { values_ = newValue as NSSet}
    }
    
    public override var description: String {
        switch unit {
        case .never: return "never"
        case .daily: return "daily"
        case .weekly:
            let days = values.sorted().compactMap { Formatters.shortDayOfWeek(for: $0) }
            let daysString = Formatters.listFormatter.string(from: days)
            if let daysString = daysString {
                return "weekly on \(daysString)"
            } else {
                return "weekly"
            }
        case .monthly:
            let day = values.sorted().compactMap{ Formatters.ordinalNumberFormatter.string(for: $0) }.first
            if let day = day {
                 return "on the \(day) of every month"
            } else {
                return "montly"
            }
        }
    }
}
