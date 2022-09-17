//
//  Droid.swift
//  DroidKit
//
//

import Foundation
#if canImport(UIKit)
import UIKit.UIColor
#endif
import CoreBluetooth

/// An instance of a Droid to send commands to.
///
/// Create a Droid instance to send commands to a Droid to change the LED color, play a sound, turn the wheel or move the Droid.
///
/// ## Sample Code
/// Get the `droid` to move forward for 2 seconds.
/// ```swift
/// let droid = Droid()
///
/// droid.onConnect {
///     droid.move(.forward, atSpeed: 0.5)
///     droid.wait(for: .seconds(2))
///     droid.stop()
/// }
/// ```
///
/// ## Topics
/// ### Setting up Droid
/// - ``init()``
/// - ``search()``
///
/// ### Controlling Movement
/// - ``move(_:atSpeed:)``
///
/// - ``turnWheel(by:)``
/// - ``turnWheel(_:by:)``
///
/// ### Customizations
/// - ``changeLEDColor(to:)``
/// - ``changeLEDColor(toRed:green:blue:)``
/// - ``playSound(_:)``
///
/// ### Handling Input
/// - ``DroidInput``
/// - ``input``
///
/// ### Pausing Execution
/// - ``wait(for:)-7gwyl``
/// - ``wait(for:)-66m9r``
///
/// ### Stopping the Droid
/// - ``stop(_:)``
///
/// ### Event Listeners
/// - ``onConnect(action:)``
/// - ``onDisconnect(action:)``
/// - ``onScan(action:)``
/// 
public final class Droid {
    private let bluetoothManager: BluetoothManagerProtocol
    
    /// Create an instance of ``Droid`` and start scanning for nearby `Droid`s.
    public init(
        bluetoothManager: BluetoothManagerProtocol = BluetoothManager.default
    ) {
        self.bluetoothManager = bluetoothManager
        // 元のコードではすぐ読んでいたが、onConnectがセットされていないと、コールバックが帰らないので自前で呼ぶ
        // search()
    }
    
    /// Moving the droid forward and backwards.
    ///
    /// ## Sample Code
    /// ### Moving droid backwards
    /// ```swift
    /// droid.move(.backward)
    /// ```
    ///
    /// ### Moving droid forwards
    /// ```swift
    /// droid.move(.forward)
    /// ```
    public enum VerticalDirection {
        case forward
        case backward
    }
    
    /// Representation of the droid's wheels direction, left or right.
    ///
    /// ## Sample Code
    /// ```swift
    /// droid.turnWheel(.left, by: 30°)
    /// ```
    ///
    public enum HorizontalDirection {
        case left, right
    }
    
    public struct Components: OptionSet {
        public let rawValue: Int
        
        public static let led = Components(rawValue: 1)
        public static let servo = Components(rawValue: 2)
        public static let motor = Components(rawValue: 3)
        
        public static let all: Components = [.led, .servo, .motor]
        public static let movement: Components = [.servo, .motor]
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
    /// Move the bot in a certain direction at a particular speed
    ///
    /// ## Sample Code
    /// ```swift
    /// droid.move()          // moves forward at 0.5 speed
    /// droid.move(.forward)  // moves forward at 0.5 speed
    /// droid.move(.backward) // moves backward at 0.5 speed
    ///
    /// droid.move(.forward, atSpeed: 0.7) // moves forward at 0.7 speed
    /// droid.move(.backward, atSpeed: 1)  // moves backward at 1 speed
    /// ```
    /// - Precondition: The `speed` should be between `0.0` and `1.0`.
    /// - Parameters:
    ///   - direction: Direction to move the droid in, `.forward` or `.backward` using ``VerticalDirection``.
    ///   - speed: Speed to move the droid.
    public func move(_ direction: VerticalDirection = .forward, atSpeed speed: Double = 0.5) {
        guard 0 ... 1 ~= speed else { return }
        let convertedSpeed = round(128 * speed)
        
        switch direction {
        case .forward:
            let motorMovement = UInt8(127 + convertedSpeed)
            sendCommand(id: 10, payload: [2, motorMovement])
        case .backward:
            let motorMovement = UInt8(128 - convertedSpeed)
            sendCommand(id: 10, payload: [2, motorMovement])
        }
    }
    
    /// Stop the Droid
    ///
    /// As the `components` is an `OptionSet`, users can select which components to stop by selecting values using an... overpowered array.
    /// ## Sample Code
    /// ### Stopping the Servo & Motor
    /// ```swift
    /// droid.stop()
    /// droid.stop(.movement)
    /// droid.stop([.servo, .motor])
    /// ```
    ///
    /// ### Stopping Servo, Motor & LED
    /// ```swift
    /// droid.stop([.movement, .led])
    /// droid.stop(.all)
    /// ```
    ///
    /// ### Stopping certain elements
    /// ```swift
    /// droid.stop(.motor)
    /// droid.stop(.servo)
    /// droid.stop(.led)
    /// ```
    ///
    /// ### Stopping a mix of elements
    /// ```swift
    /// droid.stop([.motor, .led]) // Stops the LED and Motor
    /// droid.stop([.servo])       // Stops only the Servo
    /// droid.stop([.led, .servo]) // Stops only the LED and Servo
    /// ```
    /// - Parameters:
    ///   - components: The components on the Droid to stop. By default, it stops all movement (the servo and motor).
    public func stop(_ components: Components = .movement) {
        if components.contains(.motor) {
            sendCommand(id: 10, payload: [2, 128])
        }
        if components.contains(.servo) {
            sendCommand(id: 10, payload: [1, 128])
        }
        if components.contains(.led) {
            changeLEDColor(toRed: 0, green: 0, blue: 0)
        }
    }
    
    /// Turn the wheels on the droid by an angle beween `0°` to `180°`.
    ///
    /// For a safer way to control the angle, see ``turnWheel(_:by:)``.
    ///
    /// ## Sample Code
    /// ```swift
    /// droid.turn(by: .degrees(30))      // Turns by 30 degrees
    /// droid.turn(by: .radians(.pi / 4)) // Turns by pi / 4 radians
    /// ```
    ///
    /// - Precondition: The `angle` property should be between `0°` and `180°`.
    /// - Note: Using an extreme `angle`, such as a value between `0°` to `10°`, may be too sharp a turn for the droid.
    /// - Parameter angle: The angle to turn the wheels by.
    public func turnWheel(by angle: Angle) {
        guard .degrees(0) ... .degrees(180) ~= angle else { return }
        let servoTurn = round(angle.degrees / 180 * 255)
        sendCommand(id: 10, payload: [1, UInt8(servoTurn)])
    }
    
    /// A safer way to turn the wheels by inferring the `Angle` based on the intended turn direction.
    ///
    /// For another way to manipulate the servo's angle, see ``turnWheel(by:)``.
    ///
    /// ## Sample Code
    /// ```swift
    /// droid.turn(.left, by: .degrees(30))  // Turns left by 30 degrees
    /// droid.turn(.right, by: .degrees(30)) // Turns right by 30 degrees
    ///
    /// droid.turn(.left, by: 30°)           // Turns left by 30 degrees
    /// ```
    /// - Precondition: The `angle` property should be between `0°` and `90°`.
    /// - Note: Using an extreme `angle`, such as a value between `0°` to `10°`, may be too sharp a turn for the droid.
    /// - Parameters:
    ///   - direction: Direction to turn the droid's wheels based on ``VerticalDirection``.
    ///   - angle: Angle to turn the wheels.
    public func turnWheel(_ direction: HorizontalDirection, by angle: Angle) {
        guard .degrees(0) ... .degrees(90) ~= angle else { return }
        turnWheel(by: direction == .right ? angle : .degrees(180) - angle)
    }
    
    /// Pause execution for a specific period of time
    ///
    /// This is primarily used to move forward, then wait 2 seconds before getting it to stop.
    ///
    /// ## Sample Code
    /// Get the Droid to move forward for 3 seconds.
    /// ```swift
    /// droid.move(.forward)
    /// droid.wait(for: 3.0)
    /// droid.stop()
    /// ```
    ///
    /// - Parameter seconds: The number of seconds to stop the droid.
    public func wait(for seconds: TimeInterval) {
        Thread.sleep(forTimeInterval: seconds)
    }
    
    /// Pause executuin for a specific period of time with an easier interface to input more complex timings with `Duration`.
    ///
    /// This is primarily used to move forward, then wait 2 seconds before getting it to stop.
    ///
    /// ## Sample Code
    /// Get the droid to move forward for 2 hours, then stop, _not sure why you would do that but maybe to drain its battery for no reason???_
    /// ```swift
    /// droid.move(.forward, atSpeed: 1)
    /// droid.wait(for: .hours(2))
    /// droid.stop()
    /// ```
    /// - Parameter duration: The duration it should move forward for usinf ``Duration``
    public func wait(for duration: Duration) {
        wait(for: duration.seconds)
    }
    
#if canImport(UIKit)
    /// Change LED to a specific color using a `UIColor`.
    /// ## Sample Code
    /// ```swift
    /// droid.changeLEDColor(to: .blue) // changes LED to blue
    /// droid.changeLEDColor(to: .red)  // changes LED to red
    /// ```
    /// - Parameter color: Color to change the LED to.
    public func changeLEDColor(to color: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        red *= 255
        green *= 255
        blue *= 255
        
        changeLEDColor(toRed: UInt8(red), green: UInt8(green), blue: UInt8(blue))
    }
#endif
    
    /// Change LED colour using a hexadecimal colour `String`.
    ///
    /// This method is flexible enough to support both with and without the `"#"` symbol.
    ///
    /// ## Sample Code
    /// ```swift
    /// droid.changeLEDColor(to: "#FF0000") // changes LED to red
    /// droid.changeLEDColor(to: "00FF00")  // changes LED to green
    /// ```
    /// - Parameter hexString: Hex string to change to.
    public func changeLEDColor(to hexString: String) {
        var hex = hexString.lowercased()
        if hex.hasPrefix("#") { hex.remove(at: hex.startIndex) }
        
        guard hex.count == 6, hex.allSatisfy({ $0.isHexDigit }) else { return }
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            let r = UInt8((hexNumber & 0xff0000) >> 16)
            let g = UInt8((hexNumber & 0x00ff00) >> 8)
            let b = UInt8((hexNumber & 0x0000ff))
            
            changeLEDColor(toRed: r, green: g, blue: b)
        }
    }
    
    /// Change the LED's color with a value from 0 to 255 for red, green and blue.
    ///
    /// ## Sample Code
    /// ```
    /// droid.changeLEDColor(toRed: 0, green: 0, blue: 255) // changes LED to blue
    /// droid.changeLEDColor(toRed: 0, green: 0, blue: 300) // this will not compile
    /// ```
    ///
    /// - Parameters:
    ///   - red: The color's red value
    ///   - green: The color's green value
    ///   - blue: The color's blue value
    public func changeLEDColor(toRed red: UInt8, green: UInt8, blue: UInt8) {
        let colors = [red, green, blue]
        sendCommand(id: 9, payload: colors)
    }
    
    /// Play a sound on the Droid
    ///
    /// ## Sample Code
    /// ```swift
    /// droid.playSound(1)  // Plays a sound
    /// droid.playSound(21) // Plays a sound
    /// droid.playSound(22) // Does not play sound 😢
    /// ```
    ///
    /// - Parameter sound: A value indicating the sound to play
    /// - Precondition: The property `sound` is a value from `0` to `21`, representing each individual sound track.
    public func playSound(_ sound: UInt8) {
        sendCommand(id: 15, payload: [sound])
    }
    
    /// Perform an action when the Droid connects to the device.
    ///
    /// You should run any code that commands the droid within this closure for them to run when the device connects to the droid.
    /// ## Sample Code
    /// ```swift
    /// droid.onConnect {
    ///     droid.move(.forward, atSpeed: 0.5)
    ///     droid.wait(for: .seconds(2))
    ///     droid.stop()
    /// }
    /// ```
    /// - Parameter action: The code to run when the Droid connects to the device.
    /// - Note: You should only call this function once. If you call it more than once, it will use the closure from the latest function call.
    public func onConnect(action: @escaping (() -> Void)) {
        bluetoothManager.onConnect = action
    }
    
    /// Perform an action when the Droid disconnects from the device.
    ///
    /// You should not be running any code that commands the droid as the droid would have been disconnected and unable to communciate with the device.
    ///
    /// ## Sample Code
    /// ```swift
    /// droid.onDisconnect {
    ///     print("F")
    /// }
    /// ```
    /// - Parameter action: The code to perform when the droid disconnects
    /// - Note: You should only call this function once. If you call it more than once, it will use the closure from the latest function call.
    public func onDisconnect(action: @escaping (() -> Void)) {
        bluetoothManager.onDisconnect = action
    }
    
    /// Perform an action when the device is scanning for nearby Droids.
    /// You should not be running any code that commands the droid as the droid would not be connected and thus, unable to communciate with the device.
    ///
    /// ## Sample Code
    /// ```swift
    /// droid.onScan {
    ///     print("Looking for nearby droids 👀")
    /// }
    /// ```
    /// - Parameter action: The code to perform when the droid is scanning for nearby Droids.
    /// - Note: You should only call this function once. If you call it more than once, it will use the closure from the latest function call.
    public func onScan(action: @escaping (() -> Void)) {
        bluetoothManager.onScan = action
    }
    
    /// Start searching for nearby Droids.
    ///
    /// - Warning: You do not need to call this following an `init` as it is automatically called then, however, if you would like to rescan  ``onDisconnect(action:)``, you can use this.
    public func search() {
        bluetoothManager.search()
    }
    
    private func sendCommand(id: UInt8, payload: [UInt8]) {
        bluetoothManager.sendCommand(id: id, payload: payload)
    }
}
