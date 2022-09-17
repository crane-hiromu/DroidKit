//
//  Duration.swift
//  DroidKit
//
//  Created by JiaChen(: on 1/9/21.
//

import Foundation

/// A representation of time whose value you can access in hours, minutes or seconds.
///
/// This is primarily used for setting wait times to pause execution.
///
/// ## Sample Code
/// ### Creating Durations
/// ```swift
/// let a = Duration(seconds: 20.5)
/// let b = Duration(minutes: 20)
/// let c = Duration(hours: 20)
/// let d = Duration(seconds: 50.6, minutes: 63.8)
/// let e = Duration(seconds: 50, minutes: 63, hours: 99)
///
/// let f = Duration.seconds(12.3)
/// let g = Duration.minutes(45.6)
/// let h = Duration.hours(7)
/// ```
///
/// ### Duration Arithmetic
/// ```swift
/// let i = Duration(seconds: 20) + Duration(seconds: 40)  // 1 minute
/// let j = Duration(minutes: 0.5) + Duration(seconds: 30) // 1 minute
/// let k = Duration(minutes: 30) - Duration(hours: 0.5)   // 0 seconds
/// let m = Duration(seconds: 30) * Duration(minutes: 2)   // 1 hour
/// let n = Duration(minutes: 2) / Duration(seconds: 30)   // 4 seconds
/// ```
///
/// ## Topics
/// ### Creating a Duration
/// - ``init(seconds:minutes:hours:)``
/// - ``seconds(_:)``
/// - ``minutes(_:)``
/// - ``hours(_:)``
/// - ``zero``
///
/// ### Updating Duration
/// - ``seconds``
/// - ``minutes``
/// - ``hours``
public struct Duration: Codable {
    /// The duration, represented in seconds
    public var seconds: TimeInterval
    
    /// The duration, represented in minutes
    public var minutes: TimeInterval {
        get { seconds / 60 }
        set { seconds = newValue * 60 }
    }
    
    /// The duration, represented in hours
    public var hours: TimeInterval {
        get { seconds / 3600 }
        set { seconds = newValue * 3600 }
    }
    
    /// Create a ``Duration`` with zero seconds.
    public static var zero = Duration(seconds: 0)
    
    /// Create a ``Duration`` with a mix of `seconds`, `minutes` and `hours`.
    ///
    /// As these have default values, the specific parameters do not need to be used.
    ///
    /// ## Sample Code
    /// ### Representing 1 hour
    /// ```swift
    /// let a = Duration(seconds: 3600)
    /// let b = Duration(minutes: 60)
    /// let c = Duration(hours: 1)
    /// let d = Duration(seconds: 120, minutes: 58)
    /// let e = Duration(seconds: 120, minutes: 28, hours: 0.5)
    /// ```
    ///
    /// - Parameters:
    ///   - seconds: The number of seconds, default 0
    ///   - minutes: The number of minutes, default 0
    ///   - hours: The number of hours, default 0
    public init(seconds: TimeInterval = 0, minutes: TimeInterval = 0, hours: TimeInterval = 0) {
        self.seconds = seconds + minutes * 60 + hours * 3600
    }
    
    /// Create a ``Duration`` with seconds
    /// - Parameter seconds: The number of seconds
    /// - Returns: The generated duration.
    public static func seconds(_ seconds: TimeInterval) -> Duration {
        return Duration(seconds: seconds)
    }
    
    /// Create a ``Duration`` with minutes
    /// - Parameter minutes: The number of minutes
    /// - Returns: The generated duration.
    public static func minutes(_ minutes: TimeInterval) -> Duration {
        return Duration(minutes: minutes)
    }
    
    /// Create a ``Duration`` with hours
    /// - Parameter hours: The number of hours
    /// - Returns: The generated duration.
    public static func hours(_ hours: TimeInterval) -> Duration {
        return Duration(hours: hours)
    }
}

extension Duration: Equatable {
    public static func == (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.seconds == rhs.seconds
    }
}

extension Duration: Comparable {
    public static func > (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.seconds > rhs.seconds
    }
    
    public static func < (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.seconds < rhs.seconds
    }
    
    public static func >= (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.seconds >= rhs.seconds
    }
    
    public static func <= (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.seconds <= rhs.seconds
    }
    
    public static func + (lhs: Duration, rhs: Duration) -> Duration {
        return Duration(seconds: lhs.seconds + rhs.seconds)
    }
    
    public static func += (lhs: inout Duration, rhs: Duration) {
        lhs = lhs + rhs
    }
    
    public static func - (lhs: Duration, rhs: Duration) -> Duration {
        return Duration(seconds: lhs.seconds - rhs.seconds)
    }
    
    public static func -= (lhs: inout Duration, rhs: Duration) {
        lhs = lhs - rhs
    }
    
    public static func * (lhs: Duration, rhs: Duration) -> Duration {
        return Duration(seconds: lhs.seconds * rhs.seconds)
    }
    
    public static func *= (lhs: inout Duration, rhs: Duration) {
        lhs = lhs * rhs
    }
    
    public static func / (lhs: Duration, rhs: Duration) -> Duration {
        return Duration(seconds: lhs.seconds / rhs.seconds)
    }
    
    public static func /= (lhs: inout Duration, rhs: Duration) {
        lhs = lhs / rhs
    }
}
