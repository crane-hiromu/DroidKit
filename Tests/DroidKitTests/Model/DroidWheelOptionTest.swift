//
//  DroidWheelOptionTest.swift
//  
//
//  Created by h.crane on 2022/09/18.
//

import Foundation
import XCTest
@testable import DroidKit

// MARK: - Test
final class DroidWheelOptionTest: XCTestCase {
    
    func testValue() {
        XCTContext.runActivity(named: "case .go") { _ in
            XCTAssertEqual(DroidWheelOption.go(speed: -1).value, 0)
            XCTAssertEqual(DroidWheelOption.go(speed: 0.5).value, 191)
            XCTAssertEqual(DroidWheelOption.go(speed: 2).value, 255)
        }
        
        XCTContext.runActivity(named: "case .back") { _ in
            XCTAssertEqual(DroidWheelOption.back(speed: -1).value, 0)
            XCTAssertEqual(DroidWheelOption.back(speed: 0.5).value, 64)
            XCTAssertEqual(DroidWheelOption.back(speed: 2).value, 0)
        }
        
        XCTContext.runActivity(named: "case .turn") { _ in
            XCTAssertEqual(DroidWheelOption.turn(degree: -1).value, 0)
            XCTAssertEqual(DroidWheelOption.turn(degree: 90).value, 128)
            XCTAssertEqual(DroidWheelOption.turn(degree: 181).value, 255)
        }
    }
}
