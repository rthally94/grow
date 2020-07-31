//
//  Formatters.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/18/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

struct Formatters{
    static let relativeDateFormatter: RelativeDateFormatter = {
        return RelativeDateFormatter()
    }()
    
    static let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day]
        formatter.maximumUnitCount = 1
        
        return formatter
    }()
    
    static func fullDayOfWeek(for day: Int) -> String? {
        let cal = Calendar.current
        if day < cal.weekdaySymbols.count {
            return cal.weekdaySymbols[day]
        }
        
        return nil
    }
    
    static func shortDayOfWeek(for day: Int) -> String? {
        let cal = Calendar.current
        if day < cal.shortWeekdaySymbols.count {
            return cal.shortWeekdaySymbols[day]
        }
        
        return nil
    }
    
    static func veryShortDayOfWeek(for day: Int) -> String? {
        let cal = Calendar.current
        if day < cal.veryShortStandaloneWeekdaySymbols.count {
            return cal.veryShortStandaloneWeekdaySymbols[day]
        }
        
        return nil
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    static let listFormatter: ListFormatter = ListFormatter()
    
    static let ordinalNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()
}
