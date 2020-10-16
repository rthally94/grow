//
//  UIColor+HexExtension.swift
//  GrowTests
//
//  Created by Ryan Thally on 10/12/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import XCTest
@testable import Grow_

class UIColor_HexExtension: XCTestCase {
    func testUIColor_WhenColorIsRed_StringIsHexRepresentationOfColor() {
        let sut = UIColor.red
        
        XCTAssertEqual(sut.hexString()!, "ff0000")
    }
    
    func testUIColor_WhenColorIsGreen_StringIsHexRepresentationOfColor() {
        let sut = UIColor.green
        
        XCTAssertEqual(sut.hexString()!, "00ff00")
    }
    
    func testUIColor_WhenColorIsBlue_StringIsHexRepresentationOfColor() {
        let sut = UIColor.blue
        
        XCTAssertEqual(sut.hexString()!, "0000ff")
    }
    
    func testUIColor_WhenHexIsRed_UIColorIsRed() {
        let hex = "ff0000"
        let sut = UIColor(hexString: hex)
        
        XCTAssertEqual(sut, UIColor.red)
    }
    
    func testUIColor_WhenHexIsGreen_UIColorIsGreen() {
        let hex = "00ff00"
        let sut = UIColor(hexString: hex)
        
        XCTAssertEqual(sut, UIColor.green)
    }
    
    func testUIColor_WhenHexIsBlue_UIColorIsBlue() {
        let hex = "0000ff"
        let sut = UIColor(hexString: hex)
        
        XCTAssertEqual(sut, UIColor.blue)
    }
}
