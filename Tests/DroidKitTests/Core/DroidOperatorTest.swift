//
//  DroidOperatorTest.swift
//
//
//  Created by h.crane on 2022/09/18.
//

import Foundation
import Combine
import AsyncBluetooth
import XCTest
@testable import DroidKit

// MARK: - Test
final class DroidOperatorTest: XCTestCase {
    
    func testConnect() async throws {
        let droidConnectorMock = DroidConnectorMock()
        let droidOperator = DroidOperator(connector: droidConnectorMock)
        try await droidOperator.connect()
        
        XCTAssertTrue(droidConnectorMock.scanCalled)
        XCTAssertTrue(droidConnectorMock.connectCalled)
        XCTAssertTrue(droidConnectorMock.discoverServicesCalled)
        XCTAssertTrue(droidConnectorMock.discoverCharacteristicsCalled)
        XCTAssertTrue(droidConnectorMock.setNotifyValuesCalled)
    }
    
    func testDisconnect() async throws {
        let droidConnectorMock = DroidConnectorMock()
        let droidOperator = DroidOperator(connector: droidConnectorMock)
        try await droidOperator.disconnect()
        
        XCTAssertTrue(droidConnectorMock.disconnectCalled)
    }
    
    func testAction() async throws {
        let droidConnectorMock = DroidConnectorMock()
        let droidOperator = DroidOperator(connector: droidConnectorMock)
        try await droidOperator.action(command: .moveWheel, payload: [])
        
        XCTAssertTrue(droidConnectorMock.writeValueCalled)
    }
    
    func testGo() async throws {
        let droidConnectorMock = DroidConnectorMock()
        let droidOperator = DroidOperator(connector: droidConnectorMock)
        try await droidOperator.go(at: 0.5)
        
        XCTAssertTrue(droidConnectorMock.writeValueCalled)
    }
    
    func testBack() async throws {
        let droidConnectorMock = DroidConnectorMock()
        let droidOperator = DroidOperator(connector: droidConnectorMock)
        try await droidOperator.back(at: 0.5)
        
        XCTAssertTrue(droidConnectorMock.writeValueCalled)
    }
    
    func testTurn() async throws {
        let droidConnectorMock = DroidConnectorMock()
        let droidOperator = DroidOperator(connector: droidConnectorMock)
        try await droidOperator.turn(by: 90)
        
        XCTAssertTrue(droidConnectorMock.writeValueCalled)
    }
    
    func testStop() async throws {
        let droidConnectorMock = DroidConnectorMock()
        let droidOperator = DroidOperator(connector: droidConnectorMock)
        try await droidOperator.stop(.move)
        
        XCTAssertTrue(droidConnectorMock.writeValueCalled)
    }
    
    func testChangeLEDColor() async throws {
        let droidConnectorMock = DroidConnectorMock()
        let droidOperator = DroidOperator(connector: droidConnectorMock)
        try await droidOperator.changeLEDColor(to: .clear)
        
        XCTAssertTrue(droidConnectorMock.writeValueCalled)
    }
    
    func testPlaySound() async throws {
        let droidConnectorMock = DroidConnectorMock()
        let droidOperator = DroidOperator(connector: droidConnectorMock)
        try await droidOperator.playSound(.s0)
        
        XCTAssertTrue(droidConnectorMock.writeValueCalled)
    }
    
    func testWait() {
        let expectation = expectation(description: "Wait for wait")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.wait(for: 1)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
}

// MARK: - Mock
final class DroidConnectorMock: DroidConnectorProtocol {
    
    var eventPublisher: AnyPublisher<CentralManagerEvent, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    private(set) var scanCalled = false
    func scan() async throws {
        scanCalled = true
    }
    
    private(set) var connectCalled = false
    func connect() async throws {
        connectCalled = true
    }
    
    private(set) var disconnectCalled = false
    func disconnect() async throws {
        disconnectCalled = true
    }
    
    private(set) var discoverServicesCalled = false
    func discoverServices() async throws {
        discoverServicesCalled = true
    }
    
    private(set) var discoverCharacteristicsCalled = false
    func discoverCharacteristics() async throws {
        discoverCharacteristicsCalled = true
    }
    
    private(set) var setNotifyValueCalled = false
    func setNotifyValue(with characteristic: Characteristic) async throws {
        setNotifyValueCalled = true
    }
    
    private(set) var setNotifyValuesCalled = false
    func setNotifyValues() async throws {
        setNotifyValuesCalled = true
    }
    
    private(set) var writeValueCalled = false
    func writeValue(command: UInt8, payload: [UInt8]) async throws {
        writeValueCalled = true
    }
}
