//
//  BinaryFloatingPoint+Angle.swift
//  DroidKit
//
//  Created by JiaChen(: on 1/9/21.
//

import Foundation

postfix operator °
public extension BinaryFloatingPoint where Self: Codable {
    /// Use the ° symbol to create an `Angle`
    static postfix func ° (value: Self) -> Angle {
        return Angle(degrees: Double(value))
    }
}
