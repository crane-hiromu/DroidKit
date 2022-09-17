//
//  DroidOperator.swift
//  
//
//  Created by h.crane on 2022/09/17.
//

import Foundation
import UIKit
import Combine
import AsyncBluetooth

// MARK: - Operator Protocol
protocol DroidOperatorProtocol: AnyObject {
    var eventPublisher: AnyPublisher<CentralManagerEvent, Never> { get }
    
    /// Connection Method
    func connect() async throws
    func disconnect() async throws
    
    /// Action Method
    func action(command: DroidCommand, payload: [UInt8]) async throws
    func go(at speed: Double) async throws
    func back(at speed: Double) async throws
    func turn(by degree: Double) async throws
    func stop(_ type: DroidWheel) async throws
    func changeLEDColor(to color: UIColor) async throws
    func playSound(_ type: DroidSound) async throws
    func wait(for seconds: UInt64) async throws
}

// MARK: - Operator
final class DroidOperator {
    
    // MARK: Singleton
    
    static let `default` = DroidOperator(connector: DroidConnector.default)
    private init(connector: DroidConnectorProtocol) {
        self.connector = connector
    }
    
    // MARK: Property
    
    private let connector: DroidConnectorProtocol
}

// MARK: - DroidOperatorProtocol
extension DroidOperator: DroidOperatorProtocol {
    
    /// handle event of CentralManager's state
    var eventPublisher: AnyPublisher<CentralManagerEvent, Never> {
        connector.eventPublisher
    }
    
    // MARK: Connection Method
    
    /// turn on the connection
    func connect() async throws {
        try await connector.scan()
        try await connector.connect()
        try await connector.discoverServices()
        try await connector.discoverCharacteristics()
        try await connector.setNotifyValues()
    }
    
    /// turn off the connection
    func disconnect() async throws {
        try await connector.disconnect()
    }
    
    // MARK: Action Method
    
    /// make custom actions when you add other BLE
    func action(command: DroidCommand, payload: [UInt8]) async throws {
        try await connector.writeValue(command: command.rawValue, payload: payload)
    }
    
    /// move forward
    func go(at speed: Double) async throws {
        let payload = [DroidWheel.move.rawValue, DroidWheelOption.go(speed: speed).value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// move back
    func back(at speed: Double) async throws {
        let payload = [DroidWheel.move.rawValue, DroidWheelOption.back(speed: speed).value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// turn towards
    /// - right: 0~90
    /// - left: 90~180
    func turn(by degree: Double) async throws {
        let payload = [DroidWheel.turn.rawValue, DroidWheelOption.turn(degree: degree).value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// stop moving
    func stop(_ type: DroidWheel) async throws {
        let payload = [type.rawValue, DroidWheelOption.end.value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// change body's LED ramp color
    func changeLEDColor(to color: UIColor) async throws {
        let payload = [color.asRGB.red, color.asRGB.green, color.asRGB.blue]
        try await action(command: .changeLEDColor, payload: payload)
    }
    
    /// play sound from droid
    func playSound(_ type: DroidSound) async throws {
        let payload = [type.rawValue]
        try await action(command: .playSound, payload: payload)
    }
    
    /// keep the action
    func wait(for seconds: UInt64) async throws {
        try await Task.sleep(nanoseconds: seconds * 1_000_000_000)
    }
}
