//
//  DroidOption.swift
//  
//
//  Created by h.crane on 2022/09/17.
//

import Foundation

// MARK: - Wheel Type
public enum DroidWheel: UInt8 {
    case turn = 1
    case move = 2
}

// MARK: - Wheel Option Type
public enum DroidWheelOption {
    case go(speed: Double)
    case back(speed: Double)
    case turn(degree: Double)
    case end
    
    public var value: UInt8 {
        switch self {
        case .go(let speed):
            /// if speed is less than 0, no calculation
            guard 0 < speed else { return 0 }
            /// if speed is more than 1, speed is 1
            let result = (0...1 ~= speed) ? speed : 1
            /// canvert value
            return UInt8(127 + round(128 * result))

        case .back(let speed):
            /// if speed is less than 0, no calculation
            guard 0 < speed else { return 0 }
            /// if speed is more than 1, speed is 1
            let result = (0...1 ~= speed) ? speed : 1
            /// canvert value
            return UInt8(128 - round(128 * result))
            
        case .turn(let degree):
            /// if degree is less than 0, no calculation
            guard 0 < degree else { return 0 }
            /// if degree is more than 1, degree is 180
            let result = (0...180 ~= degree) ? degree : 180
            /// canvert value
            return UInt8(round(result / 180 * 255))
            
        case .end:
            return 128
        }
    }
}
