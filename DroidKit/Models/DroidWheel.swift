//
//  DroidWheelOption.swift
//  
//
//  Created by h.tsuruta on 2022/09/17.
//

import Foundation

// MARK: - Wheel Type
enum DroidWheel: UInt8 {
    case turn = 1
    case move = 2
}

// MARK: - Wheel Option Type
enum DroidWheelOption {
    case go(speed: Double)
    case back(speed: Double)
    case turn(degree: Double)
    case end
    
    var value: UInt8 {
        switch self {
        case .go(let speed):
            return UInt8(127 + round(128 * speed))
        case .back(let speed):
            return UInt8(128 - round(128 * speed))
        case .turn(let degree):
            return UInt8(round(degree / 180 * 255))
        case .end:
            return 128
        }
    }
}
