//
//  CareIntervalTest.swift
//  GrowFrameworkTests
//
//  Created by Ryan Thally on 7/7/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import XCTest

@testable import Grow_

class CareIntervalTest: XCTestCase {
    let cal = Calendar.current
    
    // MARK: Interval
    func testCareInterval_WhenIntervalIsGreatorThanZero_IntervalIsGreatorThanZero() {
        let interval = 5
        let sut = CareInterval(unit: .daily, interval: interval)
        XCTAssertEqual(sut.interval, interval)
    }
    
    func testCareInterval_WhenIntervalIsZero_IntervalIsZero() {
        let interval = 0
        let sut = CareInterval(unit: .daily, interval: interval)
        XCTAssertEqual(sut.interval, interval)
    }
    
    func testCareInterval_WhenIntervalIsLessThanZero_IntervalIsZero() {
        let sut = CareInterval(unit: .daily, interval: -5)
        XCTAssertEqual(sut.interval, 0)
    }
    
    // MARK: Unit Interval Boundary
    func testCareInterval_WhenUnitIsNone_IntervalIsZero() {
        let unit: CareInterval.Unit = .none
        let interval = 0
        XCTAssertTrue(CareInterval.isValid(interval: interval, for: unit))
    }
    
    func test_CareInterval_WhenUnitIsNone_IntervalIsZero() {
        let sut = CareInterval(unit: .none, interval: 4)
        XCTAssertEqual(sut.interval, 0)
    }
    
    func testCareInterval_WhenUnitIsDaily_IntervalIsOne() {
        let unit: CareInterval.Unit = .daily
        let interval = 2
        XCTAssertTrue(CareInterval.isValid(interval: interval, for: unit))
    }
    
    func testCareInterval_WhenUnitIsWeekly_IntervalIsNotLessThanZero() {
        let unit: CareInterval.Unit = .weekly
        let interval = -1
        
        XCTAssertFalse(CareInterval.isValid(interval: interval, for: unit))
    }
    
    func testCareInterval_WhenUnitIsWeekly_IntervalIsNotGreaterThanNumberOfDaysInWeek() {
        let unit: CareInterval.Unit = .weekly
        let interval = 7
        
        XCTAssertFalse(CareInterval.isValid(interval: interval, for: unit))
    }
    
    func testCareInterval_WhenUnitIsMonthlyAndIntervalIsLessThanOne_IntervalIsInvalid() {
        let unit: CareInterval.Unit = .monthly
        let interval = 0
        
        XCTAssertFalse(CareInterval.isValid(interval: interval, for: unit))
    }
    
    func testCareInterval_WhenUnitIsMonthlyAndIntervalIsGreaterThanLongestMonth_IntervalIsInvalid() {
        let unit: CareInterval.Unit = .monthly
        let interval = 32
        
        XCTAssertFalse(CareInterval.isValid(interval: interval, for: unit))
    }
    
    func testCareInterval_WhenUnitIsMonthlyAndIntervalIs31_IntervalIsValid() {
        let unit: CareInterval.Unit = .monthly
        let interval = 31
        
        XCTAssertTrue(CareInterval.isValid(interval: interval, for: unit))
    }
    
    // MARK: Next Date
    func testCareInterval_WhenUnitIsDaily_NextDateIsTomorrow() {
        let sut = CareInterval(unit: .daily, interval: 1)

        let today = Date()
        let next = sut.next(from: today)
        XCTAssertTrue(cal.isDateInTomorrow(next))
    }
    
    func testCareInterval_WhenUnitIsWeekly_NextDateIsNextWeekdayOrdinal() {
        let sut = CareInterval(weekdayOrdinal: 0)
        
        let today = Date()
        
        let components = DateComponents(weekdayOrdinal: 0)
        let correct = cal.startOfDay(for: cal.nextDate(after: today, matching: components, matchingPolicy: .nextTime) ?? today)
        let next = sut.next(from: today)
        
        XCTAssertEqual(next, correct)
    }
    
    func testCareInterval_whenUnitIsMonthly_NextDateIsOneMonthLaterOnTheSameDay() {
        let sut = CareInterval(dayOfMonth: 5)
        
        let today = Date()
        let components = DateComponents(day: 5)
        let correct = cal.startOfDay(for: cal.nextDate(after: today, matching: components, matchingPolicy: .previousTimePreservingSmallerComponents) ?? today)
        
        let next = sut.next(from: today)
        
        XCTAssertEqual(next, correct)
    }
    
    func testCareInterval_whenUnitIsMonthlyAndDayIs31_NextDateIsOn30() {
        let sut = CareInterval(dayOfMonth: 31)
        
        let date = cal.date(bySetting: .month, value: 9, of: Date())!
        let components = DateComponents(day: 31)
        
        let correct = cal.startOfDay(for: cal.nextDate(after: date, matching: components, matchingPolicy: .previousTimePreservingSmallerComponents)!)
        let next = sut.next(from: date)
        XCTAssertEqual(next, correct)
    }
}
