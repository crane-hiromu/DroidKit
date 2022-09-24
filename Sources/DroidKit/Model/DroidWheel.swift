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
    static let endValue: UInt8 = 128
}

// MARK: - Action Protocol
protocol DroidWheelAction {
    var value: UInt8 { get }
}

// MARK: - Movement Action Type
public enum DroidWheelMovementAction: DroidWheelAction {
    case go(speed: Double)
    case back(speed: Double)
    case end
    
    public var value: UInt8 {
        switch self {
        case .go(let speed):
            /// if speed is less than 0, no calculation
            guard 0 < speed else { return 0 }
            /// if speed is more than 1, speed is 1
            let result = (0...1 ~= speed) ? speed : Double(1)
            /// canvert value
            return UInt8(127 + round(Double(128) * result))

        case .back(let speed):
            /// if speed is less than 0, no calculation
            guard 0 < speed else { return 0 }
            /// if speed is more than 1, speed is 1
            let result = (0...1 ~= speed) ? speed : Double(1)
            /// canvert value
            return UInt8(128 - round(Double(128) * result))
            
        case .end:
            return DroidWheel.endValue
        }
    }
}

// MARK: - Turn Action Type
public enum DroidWheelTurnAction: DroidWheelAction {
    case turn(degree: Double)
    case end
    
    public var value: UInt8 {
        switch self {
        case .turn(let degree):
            /// if degree is less than 0, no calculation
            guard 0 < degree else { return 0 }
            /// if degree is more than 1, degree is 180
            let result = (0...180 ~= degree) ? degree : Double(180)
            /// canvert value
            return UInt8(round(result / Double(180) * Double(255)))
            
        case .end:
            return DroidWheel.endValue
        }
    }
}
