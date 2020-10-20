//
//  CareTaskTests.swift
//  GrowTests
//
//  Created by Ryan Thally on 10/20/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import XCTest

import CoreData
@testable import Grow_

class CareTaskTests: XCTestCase {
    private let testingContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    private func makeSUT(unit: CareTask.IntervalUnit = .never, values: Set<Int> = []) -> CareTask {
        let context = testingContext
        
        let task = CareTask(context: context)
        task.intervalUnit = unit
        task.intervalValues = values
        
        return task
    }
    
    private func makeLog() -> CareTaskLog {
        let log = CareTaskLog(context: testingContext)
        
        return log
    }

    // Tests with no logs
    func testCareTask_WhenIntervalIsNever_NextCareDateIsNil() {
        let sut = makeSUT()
        
        XCTAssertNil(sut.nextCareDate(for: Date()))
    }
    
    func testCareTask_WhenIntervalIsDailyWithNoLogs_NextCareDateIsToday() throws {
        let sut = makeSUT(unit: .daily)
        
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let nextCareDate = try XCTUnwrap(sut.nextCareDate(for: startOfToday))
        
        XCTAssertEqual(nextCareDate, startOfToday)
    }
    
    func testCareTask_WhenIntervalIsWeeklyWithNoLogsAndCurrentWeekdayIsSunday_NextCareDateIsSunday() throws {
        let testDateComponents = DateComponents(year: 2020, month: 1, day: 5)
        let testDate = try XCTUnwrap(Calendar.current.date(from: testDateComponents))
        
        let sut = makeSUT(unit: .weekly, values: [1])
        
        let nextCareDate = try XCTUnwrap(sut.nextCareDate(for: testDate))
        
        XCTAssertEqual(testDate, nextCareDate)
    }
    
    func testCareTask_WhenIntervalIsWeeklyWithNoLogsAndCurrentWeekdayIsWednesday_NextCareDateIsSunday() throws {
        let testDateComponents = DateComponents(year: 2020, month: 1, day: 1)
        let testDate = try XCTUnwrap(Calendar.current.date(from: testDateComponents))
        
        let sut = makeSUT(unit: .weekly, values: [1])
        
        let nextCareDate = try XCTUnwrap(sut.nextCareDate(for: testDate))
        
        let correctDateComponents = DateComponents(year: 2020, month: 1, day: 5)
        let correctDate = try XCTUnwrap(Calendar.current.date(from: correctDateComponents))
        
        XCTAssertEqual(correctDate, nextCareDate)
    }
    
    func testCareTask_WhenIntervalIsMonthlyWithNoLogsAndCurrentDayIs1_NextCareDateIs1OfTheSameMonth() throws {
        let day = 1
        
        let testDateComponents = DateComponents(year: 2020, month: 1, day: day)
        let testDate = try XCTUnwrap(Calendar.current.date(from: testDateComponents))
        
        let sut = makeSUT(unit: .monthly, values: [1])
        
        let nextCareDate = try XCTUnwrap(sut.nextCareDate(for: testDate))
        
        XCTAssertEqual(testDate, nextCareDate)
    }
    
    func testCareTask_WhenIntervalIsMonthlyWithNoLogsAndCurrentWeekdayIsAfter1_NextCareDateIs1OfTheNextMonth() throws {
        let day = 2
        
        let testDateComponents = DateComponents(year: 2020, month: 1, day: day)
        let testDate = try XCTUnwrap(Calendar.current.date(from: testDateComponents))
        
        let sut = makeSUT(unit: .monthly, values: [1])
        
        let nextCareDate = try XCTUnwrap(sut.nextCareDate(for: testDate))
        
        let correctDateComponents = DateComponents(year: 2020, month: 2, day: 1)
        let correctDate = try XCTUnwrap(Calendar.current.date(from: correctDateComponents))
        
        XCTAssertEqual(correctDate, nextCareDate)
    }
    
    // Tests with logs
    func testCareTask_WhenIntervalIsNeverWithLog_NextCareDateIsNil() throws {
        let sut = makeSUT()
        
        let testDateComponents = DateComponents(year: 2020, month: 1, day: 1)
        let testDate = try XCTUnwrap(Calendar.current.date(from: testDateComponents))
        
        let testLog = makeLog()
        testLog.date = testDate
        sut.addToLogs_(testLog)
        
        XCTAssertNil(sut.nextCareDate(for: testDate))
    }
    
    func testCareTask_WhenIntervalIsDailyWithLog_NextCareDateIsTheNextDay() throws {
        let sut = makeSUT(unit: .daily)
        
        let testDateComponents = DateComponents(year: 2020, month: 1, day: 5)
        let testDate = try XCTUnwrap(Calendar.current.date(from: testDateComponents))
        
        let testLog = makeLog()
        testLog.date = testDate
        sut.addToLogs_(testLog)
        
        let nextCareDate = try XCTUnwrap(sut.nextCareDate(for: testDate))
        
        let correctDateComponents = DateComponents(year: 2020, month: 1, day: 6)
        let correctDate = try XCTUnwrap(Calendar.current.date(from: correctDateComponents))
        
        XCTAssertEqual(correctDate, nextCareDate)
    }
    
    func testCareTask_WhenIntervalIsWeeklyOnSundayWithLogAndCurrentWeekdayIsSunday_NextCareDateIsSunday() throws {
        let testDateComponents = DateComponents(year: 2020, month: 1, day: 5)
        let testDate = try XCTUnwrap(Calendar.current.date(from: testDateComponents))
        
        let sut = makeSUT(unit: .weekly, values: [1])
        
        let testLog = makeLog()
        testLog.date = testDate
        sut.addToLogs_(testLog)
        
        let nextCareDate = try XCTUnwrap(sut.nextCareDate(for: testDate))
        
        let correctDateComponents = DateComponents(year: 2020, month: 1, day: 12)
        let correctDate = try XCTUnwrap(Calendar.current.date(from: correctDateComponents))
        
        XCTAssertEqual(correctDate, nextCareDate)
    }
    
    func testCareTask_WhenIntervalIsWeeklyWithLogAndCurrentWeekdayIsWednesday_NextCareDateIsSunday() throws {
        // Logged on Sunday 1/5, Today is Wednesday 1/8, Next should be Sunday 1/12
        
        let testDateComponents = DateComponents(year: 2020, month: 1, day: 8)
        let testDate = try XCTUnwrap(Calendar.current.date(from: testDateComponents))
        
        let sut = makeSUT(unit: .weekly, values: [1])
        
        let logDateComponents = DateComponents(year: 2020, month: 1, day: 5)
        let logDate = try XCTUnwrap(Calendar.current.date(from: logDateComponents))
        let testLog = makeLog()
        testLog.date = logDate
        sut.addToLogs_(testLog)
        
        let nextCareDate = try XCTUnwrap(sut.nextCareDate(for: testDate))
        
        let correctDateComponents = DateComponents(year: 2020, month: 1, day: 12)
        let correctDate = try XCTUnwrap(Calendar.current.date(from: correctDateComponents))
        
        XCTAssertEqual(correctDate, nextCareDate)
    }
    
    func testCareTask_WhenIntervalIsMonthlyWithLogAndCurrentDayIs1_NextCareDateIs1OfTheNextMonth() throws {
        let day = 1
        
        let testDateComponents = DateComponents(year: 2020, month: 1, day: day)
        let testDate = try XCTUnwrap(Calendar.current.date(from: testDateComponents))
        
        let sut = makeSUT(unit: .monthly, values: [1])
        
        let logDateComponents = DateComponents(year: 2020, month: 1, day: 1)
        let logDate = try XCTUnwrap(Calendar.current.date(from: logDateComponents))
        let testLog = makeLog()
        testLog.date = logDate
        sut.addToLogs_(testLog)
        
        let nextCareDate = try XCTUnwrap(sut.nextCareDate(for: testDate))
        
        let correctDateComponents = DateComponents(year: 2020, month: 2, day: 1)
        let correctDate = try XCTUnwrap(Calendar.current.date(from: correctDateComponents))
        
        XCTAssertEqual(correctDate, nextCareDate)
    }
    
    func testCareTask_WhenIntervalIsMonthlyWithLogAndCurrentDayIs5_NextCareDateIs1OfTheNextMonth() throws {
        let testDateComponents = DateComponents(year: 2020, month: 1, day: 5)
        let testDate = try XCTUnwrap(Calendar.current.date(from: testDateComponents))
        
        let sut = makeSUT(unit: .monthly, values: [1])
        
        let logDateComponents = DateComponents(year: 2020, month: 1, day: 1)
        let logDate = try XCTUnwrap(Calendar.current.date(from: logDateComponents))
        let testLog = makeLog()
        testLog.date = logDate
        sut.addToLogs_(testLog)
        
        let nextCareDate = try XCTUnwrap(sut.nextCareDate(for: testDate))
        
        let correctDateComponents = DateComponents(year: 2020, month: 2, day: 1)
        let correctDate = try XCTUnwrap(Calendar.current.date(from: correctDateComponents))
        
        XCTAssertEqual(correctDate, nextCareDate)
    }
}
