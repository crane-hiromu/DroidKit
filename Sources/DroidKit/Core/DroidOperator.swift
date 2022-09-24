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
public protocol DroidOperatorProtocol: AnyObject {
    var eventPublisher: AnyPublisher<CentralManagerEvent, Never> { get }
    
    /// Connection Method
    func connect() async throws
    func disconnect() async throws
    
    /// Action Method
    func action(command: DroidCommand, payload: [UInt8]) async throws
    func go(at speed: Double) async throws
    func back(at speed: Double) async throws
    func turn(by degree: Double) async throws
    func stop() async throws
    func endTurn() async throws
    func changeLEDColor(to color: UIColor) async throws
    func playSound(_ type: DroidSound) async throws
    func wait(for seconds: Double) async throws
}

// MARK: - Operator
public final class DroidOperator {
    
    // MARK: Singleton
    
    public static let `default` = DroidOperator(connector: DroidConnector.default)
    init(connector: DroidConnectorProtocol) {
        self.connector = connector
    }
    
    // MARK: Property
    
    private let connector: DroidConnectorProtocol
}

// MARK: - DroidOperatorProtocol
extension DroidOperator: DroidOperatorProtocol {
    
    /// handle event of CentralManager's state
    public var eventPublisher: AnyPublisher<CentralManagerEvent, Never> {
        connector
            .eventPublisher
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: Connection Method
    
    /// turn on the connection
    public func connect() async throws {
        try await connector.scan()
        try await connector.connect()
        try await connector.discoverServices()
        try await connector.discoverCharacteristics()
        try await connector.setNotifyValues()
    }
    
    /// turn off the connection
    public func disconnect() async throws {
        try await connector.disconnect()
    }
    
    // MARK: Action Method
    
    /// make custom actions when you add other BLE
    public func action(command: DroidCommand, payload: [UInt8]) async throws {
        try await connector.writeValue(command: command.rawValue, payload: payload)
    }
    
    /// move forward
    public func go(at speed: Double) async throws {
        let payload = [DroidWheel.move.rawValue, DroidWheelMovementAction.go(speed: speed).value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// move back
    public func back(at speed: Double) async throws {
        let payload = [DroidWheel.move.rawValue, DroidWheelMovementAction.back(speed: speed).value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// turn towards
    /// - right: 0~90
    /// - left: 90~180
    public func turn(by degree: Double) async throws {
        let payload = [DroidWheel.turn.rawValue, DroidWheelTurnAction.turn(degree: degree).value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// stop moving
    public func stop() async throws {
        let payload = [DroidWheel.move.rawValue, DroidWheelMovementAction.end.value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// reset  wheel degree
    public func endTurn() async throws {
        let payload = [DroidWheel.turn.rawValue, DroidWheelTurnAction.end.value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// change body's LED ramp color
    public func changeLEDColor(to color: UIColor) async throws {
        let payload = [color.asRGB.red, color.asRGB.green, color.asRGB.blue]
        try await action(command: .changeLEDColor, payload: payload)
    }
    
    /// play sound from droid
    public func playSound(_ type: DroidSound) async throws {
        let payload = [type.rawValue]
        try await action(command: .playSound, payload: payload)
    }
    
    /// keep the action
    public func wait(for seconds: Double) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds) * 1_000_000_000)
    }
}
