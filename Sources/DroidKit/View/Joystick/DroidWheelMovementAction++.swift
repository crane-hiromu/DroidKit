//
//  DroidWheel.swift
//
//
//  Created by h.tsuruta on 2022/12/26.
//

import SwiftUI

// MARK: - Equatable
@available(iOS 15.0, *)
extension DroidWheelMovementAction: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        if case .go(let s1) = lhs, case .go(let s2) = rhs { return s1 == s2 }
        if case .back(let s1) = lhs, case .back(let s2) = rhs { return s1 == s2 }
        if case .end = lhs, case .end = rhs { return true }
        // Returns false if pattern does not match
        return false
    }
    
    public static func joystick(params: (radius: CGFloat, point: CGPoint)) -> Self {
        let point = params.point
        // Calculate point distance
        let pointDistance = round(sqrt(pow(point.y, 2) + pow(point.x, 2)))
        // Calculate speed
        let speed = pointDistance / params.radius
        // Round speed, ex 0.567.. -> 0.6
        let roundedSpeed = round(speed * 10.0) / 10.0
        // Judge forward, backward, and stop
        switch point.y {
        case let y where y < 0:  return .go(speed: roundedSpeed)
        case let y where 0 < y:  return .back(speed: roundedSpeed)
        default:                 return .end
        }
    }
}
