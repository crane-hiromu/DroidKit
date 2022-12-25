//
//  DroidWheel.swift
//
//
//  Created by h.tsuruta on 2022/12/26.
//

import SwiftUI

// MARK: - Equatable
@available(iOS 15.0, *)
extension DroidWheelTurnAction: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        if case .turn(let d1) = lhs, case .turn(let d2) = rhs { return d1 == d2 }
        if case .end = lhs, case .end = rhs { return true }
        // Returns false if pattern does not match
        return false
    }
    
    public static func joystick(point: CGPoint) -> Self {
        let x = point.x < 0 ? -point.x : point.x
        let y = point.y < 0 ? -point.y : point.y
        // Get arctangent result
        let result = atan(y/x)
        // Check value to avoid crash
        if result.isNaN { return .end }
        // Calculate degree
        let degree = result * 180 / Double.pi
        // Correct degree between right and left
        let correctedDegree = point.x < 0 ? 180 - degree : degree
        // Round degree, ex 17°->20° 22°->20°
        let roundedDegree = round(correctedDegree / 10.0) * 10.0
        // Droid doesn't move when the wheel is vertical
        // Round degree if it's less than 30° or greater than 150°
        switch roundedDegree {
        case let d where d.isNaN:  return .end
        case let d where d < 30:   return .turn(degree: 30)
        case let d where 150 < d:  return .turn(degree: 150)
        default:                   return .turn(degree: roundedDegree)
        }
    }
}

