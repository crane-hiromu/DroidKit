//
//  Angle.swift
//  DroidKit
//
//  Created by JiaChen(: on 1/9/21.
//

import Foundation

/// A geometric angle whose value you access in either radians or degrees.
///
/// ## Sample Code
/// ### Creating an Angle
/// ```swift
/// let a = Angle(degrees: 45)
/// let b = Angle(radians: .pi / 4)
/// let c = Angle.degrees(45)
/// let d = Angle.radians(.pi / 4)
/// let f = 45° // 🤯 🤯, use the degrees symbol (hold down on 0️⃣ on iPad Keyboard)
/// let g = Angle.zero // zero degrees or radians
/// ```
/// ### Angle Arithmetic
/// ```swift
/// let h = Angle(degrees: 45) + Angle(degrees: 45)      // 90 degrees
/// let i = Angle(degrees: 45) + Angle(radians: .pi / 4) // 90 degrees
/// let j = Angle(degrees: 45) - Angle(degrees: 45)      // 0 degrees
/// let k = Angle(degrees: 45) - Angle(radians: .pi / 4) // 0 degrees
/// let l = Angle(degrees: 45) * Angle(radians: .pi / 4) // 2025 degrees
/// let m = Angle(degrees: 45) / Angle(radians: .pi / 4) // 1 degree
/// ```
///
/// ### Angle Comparison
/// ```swift
/// Angle(degrees: 45) == Angle(radians: .pi / 4) // true
/// Angle(degrees: 20) == Angle(radians: .pi / 4) // false
/// Angle(degrees: 45) != Angle(radians: .pi / 4) // false
/// Angle(degrees: 20) != Angle(radians: .pi / 4) // true
///
/// Angle(degrees: 45) >= Angle(radians: .pi / 2) // true
/// Angle(degrees: 45) <= Angle(radians: .pi / 2) // true
/// Angle(degrees: 20) >= Angle(radians: .pi / 4) // false
/// Angle(degrees: 20) <= Angle(radians: .pi / 4) // false
/// ```
///
/// ## Topics
/// ### Creating an Angle
/// - ``init(degrees:)``
/// - ``init(radians:)``
/// - ``degrees(_:)``
/// - ``radians(_:)``
/// - ``zero``
///
/// ### Updating an Angle
/// - ``degrees``
/// - ``radians``
///
public struct Angle: Hashable, Codable {
    
    /// Zero degrees
    static public var zero: Angle = Angle(degrees: 0)
    
    /// The angle, represented in radians
    public var degrees: Double
    
    /// The angle, represented in radians
    public var radians: Double {
        get {
            return degrees / (180 / .pi)
        }
        set {
            self.degrees = newValue * 180 / .pi
        }
    }
    
    /// Create an Angle with radians
    public init(radians: Double) {
        self.degrees = radians * 180 / .pi
    }
    
    /// Create an Angle with degrees
    public init(degrees: Double) {
        self.degrees = degrees
    }
    
    /// Create an Angle with degrees
    public static func degrees(_ degree: Double) -> Angle {
        return Angle(degrees: degree)
    }
    
    /// Create an Angle with radians
    public static func radians(_ radian: Double) -> Angle {
        return Angle(radians: radian)
    }
}

extension Angle: Comparable, Equatable {
    public static func > (lhs: Angle, rhs: Angle) -> Bool {
        return lhs.degrees > rhs.degrees
    }
    
    public static func < (lhs: Angle, rhs: Angle) -> Bool {
        return lhs.degrees < rhs.degrees
    }
    
    public static func >= (lhs: Angle, rhs: Angle) -> Bool {
        return lhs.degrees >= rhs.degrees
    }
    
    public static func <= (lhs: Angle, rhs: Angle) -> Bool {
        return lhs.degrees <= rhs.degrees
    }
    
    public static func == (lhs: Angle, rhs: Angle) -> Bool {
        return Double(lhs.degrees) == Double(rhs.degrees)
    }
    
    /// Add the `Angle` to another `Angle`.
    public static func + (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(degrees:lhs.degrees + rhs.degrees)
    }
    
    /// Increment the `Angle` by another `Angle`.
    public static func += (lhs: inout Angle, rhs: Angle) {
        lhs = lhs + rhs
    }
    
    /// Subtract the `Angle` by another `Angle`.
    public static func - (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(degrees: lhs.degrees - rhs.degrees)
    }
    
    /// Decrement the `Angle` by another `Angle`.
    public static func -= (lhs: inout Angle, rhs: Angle) {
        lhs = lhs - rhs
    }
    
    /// Multiply the `Angle` by another `Angle`.
    public static func * (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(degrees: lhs.degrees * rhs.degrees)
    }
    
    /// Multiply the `Angle` by another `Angle`.
    public static func *= (lhs: inout Angle, rhs: Angle) {
        lhs = lhs * rhs
    }
    
    /// Divide the `Angle` by another `Angle`.
    public static func / (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(degrees: lhs.degrees / rhs.degrees)
    }
    
    /// Divide the `Angle` by another `Angle`.
    public static func /= (lhs: inout Angle, rhs: Angle) {
        lhs = lhs / rhs
    }
}

extension Angle: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "\(degrees)°"
    }
    
    public var debugDescription: String {
        "Angle: \(degrees)° / \(radians)rad"
    }
}
