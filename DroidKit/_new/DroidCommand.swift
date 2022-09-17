//
//  DroidCommand.swift
//  
//
//  Created by h.tsuruta on 2022/09/17.
//

import Foundation

// MARK: - Command Type
enum DroidCommand: UInt8 {
    case changeLEDColor = 9
    case moveWheel = 10
    case playSound = 15
}

// MARK: - Wheel Type
enum WheelType: UInt8 {
    // First Value
    case turn = 1
    case move = 2
    
    // Second Value
    static let end: UInt8 = 128
    static func go(at speed: Double) -> UInt8 {
        UInt8(127 + round(128 * speed))
    }
    static func back(at speed: Double) -> UInt8 {
        UInt8(128 - round(128 * speed))
    }
    static func turn(by degree: Double) -> UInt8 {
        UInt8(round(degree / 180 * 255))
    }
}
