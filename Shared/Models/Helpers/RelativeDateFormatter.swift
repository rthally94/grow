//
//  RelativeDateFormatter.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/18/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

class RelativeDateFormatter: Formatter {
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var locale: Locale {
        set {
            dateFormatter.locale = newValue
            relativeDateFormatter.locale = newValue
        }
        
        get {
            return dateFormatter.locale
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter.doesRelativeDateFormatting = true
        
        return formatter
    }()
    
    let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
            
        formatter.unitsStyle = .full
        formatter.dateTimeStyle = .numeric
        
        return formatter
    }()
    
    func string(for date: Date) -> String {
        let cal = Calendar.current
        
        if cal.isDateInToday(date) || cal.isDateInTomorrow(date) {
            return dateFormatter.string(from: date)
        } else {
            let sanitizedToday = cal.date(from: cal.dateComponents([.year, .month, .day], from: Date())) ?? Date()
            let sanitizedDate = cal.date(from: cal.dateComponents([.year, .month, .day], from: date)) ?? Date()
            return relativeDateFormatter.localizedString(for: sanitizedDate, relativeTo: sanitizedToday)
        }
    }
    
    override func string(for obj: Any?) -> String? {
        guard let date = obj as? Date else { return nil }
        return string(for: date)
    }
}
