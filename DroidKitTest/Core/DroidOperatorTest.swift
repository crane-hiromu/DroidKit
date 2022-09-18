//
//  DroidOperatorTest.swift
//
//
//  Created by h.tsuruta on 2022/09/18.
//

#if TESTING_ENABLED

import Foundation
import Combine
import AsyncBluetooth
import PlaygroundTester

@objcMembers
final class DroidOperatorTest: TestCase {
    
    func testConnect() throws {
        let expectation = Expectation(name: "Wait for connect")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.connect()
            
            Assert(droidConnectorMock.scanCalled)
            Assert(droidConnectorMock.connectCalled)
            Assert(droidConnectorMock.discoverServicesCalled)
            Assert(droidConnectorMock.discoverCharacteristicsCalled)
            Assert(droidConnectorMock.setNotifyValuesCalled)
            expectation.fulfill()
        }
        AssertExpectations([expectation], timeout: 1)
    }
    
    func testDisconnect() {
        let expectation = Expectation(name: "Wait for disconnect")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.disconnect()
            
            Assert(droidConnectorMock.disconnectCalled)
            expectation.fulfill()
        }
        AssertExpectations([expectation], timeout: 1)
    }
    
    func testAction() {
        let expectation = Expectation(name: "Wait for action")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.action(command: .moveWheel, payload: [])
            
            Assert(droidConnectorMock.writeValueCalled)
            expectation.fulfill()
        }
        AssertExpectations([expectation], timeout: 1)
    }
    
    func testGo() {
        let expectation = Expectation(name: "Wait for go")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.go(at: 0.5)
            
            Assert(droidConnectorMock.writeValueCalled)
            expectation.fulfill()
        }
        AssertExpectations([expectation], timeout: 1)
    }
    
    func testBack() {
        let expectation = Expectation(name: "Wait for back")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.back(at: 0.5)
            
            Assert(droidConnectorMock.writeValueCalled)
            expectation.fulfill()
        }
        AssertExpectations([expectation], timeout: 1)
    }
    
    func testTurn() {
        let expectation = Expectation(name: "Wait for turn")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.turn(by: 90)
            
            Assert(droidConnectorMock.writeValueCalled)
            expectation.fulfill()
        }
        AssertExpectations([expectation], timeout: 1)
    }
    
    func testStop() {
        let expectation = Expectation(name: "Wait for stop")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.stop(.move)
            
            Assert(droidConnectorMock.writeValueCalled)
            expectation.fulfill()
        }
        AssertExpectations([expectation], timeout: 1)
    }
    
    func testChangeLEDColor() {
        let expectation = Expectation(name: "Wait for changeLEDColor")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.changeLEDColor(to: .clear)
            
            Assert(droidConnectorMock.writeValueCalled)
            expectation.fulfill()
        }
        AssertExpectations([expectation], timeout: 1)
    }
    
    func testPlaySound() {
        let expectation = Expectation(name: "Wait for playSound")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.playSound(.s0)
            
            Assert(droidConnectorMock.writeValueCalled)
            expectation.fulfill()
        }
        AssertExpectations([expectation], timeout: 1)
    }
    
    func testWait() {
        let expectation = Expectation(name: "Wait for wait")
        Task {
            let droidConnectorMock = DroidConnectorMock()
            let droidOperator = DroidOperator(connector: droidConnectorMock)
            try await droidOperator.wait(for: 1)
            
            
            expectation.fulfill()
        }
        AssertExpectations([expectation], timeout: 2)
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

#endif
