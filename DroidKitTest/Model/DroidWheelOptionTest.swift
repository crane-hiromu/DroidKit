//
//  DroidWheelOptionTest.swift
//  
//
//  Created by h.tsuruta on 2022/09/18.
//

#if TESTING_ENABLED

import Foundation
import PlaygroundTester

@objcMembers
final class DroidWheelOptionTest: TestCase {
    
    func testValue() {
        // case .go
        do {
            AssertEqual(DroidWheelOption.go(speed: -1).value, other: 0)
            AssertEqual(DroidWheelOption.go(speed: 0.5).value, other: 191)
            AssertEqual(DroidWheelOption.go(speed: 2).value, other: 255)
        }
        
        // case .back
        do {
            AssertEqual(DroidWheelOption.back(speed: -1).value, other: 0)
            AssertEqual(DroidWheelOption.back(speed: 0.5).value, other: 64)
            AssertEqual(DroidWheelOption.back(speed: 2).value, other: 0)
        }
        
        // case .turn
        do {
            AssertEqual(DroidWheelOption.turn(degree: -1).value, other: 0)
            AssertEqual(DroidWheelOption.turn(degree: 90).value, other: 128)
            AssertEqual(DroidWheelOption.turn(degree: 181).value, other: 255)
        }
    }
}

#endif
