//
//  Date+Extension.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/29/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
extension Date {
    var startOfWeek: Date? {
        if Calendar.current.component(.weekday, from: self) == 1 {
            return self
        } else {
            return Calendar.current.nextDate(after: self, matching: .init(weekday: 1), matchingPolicy: .nextTime, direction: .backward)
        }
    }
    
    var endofWeek: Date? {
        if Calendar.current.component(.weekday, from: self) == 7 {
            return self
        } else {
            return Calendar.current.nextDate(after: self, matching: .init(weekday: 7), matchingPolicy: .previousTimePreservingSmallerComponents, direction: .forward)
        }
    }
}
