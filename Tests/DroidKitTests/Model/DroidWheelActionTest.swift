//
//  DroidWheelActionTest.swift
//  
//
//  Created by h.crane on 2022/09/18.
//

import Foundation
import XCTest
@testable import DroidKit

// MARK: - Test
final class DroidWheelActionTest: XCTestCase {
    
    func testMovementActionValue() {
        XCTContext.runActivity(named: "case .go") { _ in
            XCTAssertEqual(DroidWheelMovementAction.go(speed: -1).value, 0)
            XCTAssertEqual(DroidWheelMovementAction.go(speed: 0.5).value, 191)
            XCTAssertEqual(DroidWheelMovementAction.go(speed: 2).value, 255)
        }
        
        XCTContext.runActivity(named: "case .back") { _ in
            XCTAssertEqual(DroidWheelMovementAction.back(speed: -1).value, 0)
            XCTAssertEqual(DroidWheelMovementAction.back(speed: 0.5).value, 64)
            XCTAssertEqual(DroidWheelMovementAction.back(speed: 2).value, 0)
        }
        
        XCTContext.runActivity(named: "case .end") { _ in
            XCTAssertEqual(DroidWheelMovementAction.end.value, 128)
        }
    }
    
    func testTurnActionValue() {
        XCTContext.runActivity(named: "case .turn") { _ in
            XCTAssertEqual(DroidWheelTurnAction.turn(degree: -1).value, 0)
            XCTAssertEqual(DroidWheelTurnAction.turn(degree: 90).value, 128)
            XCTAssertEqual(DroidWheelTurnAction.turn(degree: 181).value, 255)
        }
        
        XCTContext.runActivity(named: "case .end") { _ in
            XCTAssertEqual(DroidWheelTurnAction.end.value, 128)
        }
    }
}
