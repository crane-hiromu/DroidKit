//
//  DroidManager.swift
//  
//
//  Created by h.crane on 2022/09/15.
//

import Foundation
import Combine
import AsyncBluetooth
import UIKit

// MARK: - Connector Protocol
public protocol DroidConnectorProtocol: AnyObject {
    var eventPublisher: AnyPublisher<CentralManagerEvent, Never> { get }
    
    /// CentralManager Method
    func scan() async throws
    func connect() async throws
    func disconnect() async throws
    
    /// Peripheral Method
    func discoverServices() async throws
    func discoverCharacteristics() async throws
    func setNotifyValue(with characteristic: Characteristic) async throws
    func setNotifyValues() async throws
    func writeValue(command: UInt8, payload: [UInt8]) async throws
}

// MARK: - Manager
public final class DroidConnector {
    
    // MARK: Singleton
    
    public static let `default` = DroidConnector()
    private init() {}
    
    // MARK: Property
    
    private let centralManager = CentralManager()
    private var scanData: ScanData?
}

// MARK: - DroidManagerProtocol
extension DroidConnector: DroidConnectorProtocol {
    
    /// handle event of CentralManager's state
    public var eventPublisher: AnyPublisher<CentralManagerEvent, Never> {
        centralManager.eventPublisher
    }
    
    // MARK: CentralManager Method
    
    /// scan BLE service id
    public func scan() async throws {
        try await centralManager.waitUntilReady()
        
        let ids = [DroidBLE.UUID_W32_SERVICE.uuid]
        let scanDataStream = try await centralManager.scanForPeripherals(withServices: ids)
        for await scanData in scanDataStream {
            if scanData.peripheral.name == DroidBLE.W32_CONTROL_HUB {
                self.scanData = scanData
                break
            }
        }
        await centralManager.stopScan()
    }
    
    /// connect BLE service
    public func connect() async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        try await centralManager.connect(data.peripheral)
    }
    
    /// disconnect BLE service
    public func disconnect() async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        try await centralManager.cancelPeripheralConnection(data.peripheral)
    }
    
    // MARK: Peripheral Method
    
    public func discoverServices() async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        let ids = [DroidBLE.UUID_W32_SERVICE.uuid]
        try await data.peripheral.discoverServices(ids)
    }
    
    public func discoverCharacteristics() async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        // if you want to connect multiple droid, please update code
        guard let service = data.peripheral.discoveredServices?.first else {
            throw DroidError.noDiscoverServices
        }
        
        let types: [DroidBLE] = [
            .W32_AUDIO_UPLOAD_CHARACTERISTIC,
            .W32_BITSNAP_CHARACTERISTIC,
            .W32_BOARD_CONTROL_CHARACTERISTIC
        ]
        let ids = types.map(\.uuid)
        
        try await data.peripheral.discoverCharacteristics(ids, for: service)
    }
    
    public func setNotifyValue(with characteristic: Characteristic) async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        try await data.peripheral.discoverDescriptors(for: characteristic)
        let uuid = characteristic.uuid.uuidString.lowercased()
        
        guard let _ = DroidBLE(rawValue: uuid) else {
            throw DroidError.noBluetoothType
        }
        try await data.peripheral.setNotifyValue(true, for: characteristic)
    }
    
    public func setNotifyValues() async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        
        let chars = data.peripheral
            .discoveredServices?
            .compactMap(\.discoveredCharacteristics)
            .flatMap { $0 } ?? []
        
        for char in chars {
            do {
                try await setNotifyValue(with: char)
            } catch {
                debugPrint("error: \(error)")
            }
        }
    }
    
    public func writeValue(command: UInt8, payload: [UInt8]) async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        guard let characteristic = getCharacteristic(from: .W32_BITSNAP_CHARACTERISTIC) else {
            throw DroidError.noCharacteristic
        }
        let value = rawData(command: command, payload: payload)
        try await data.peripheral.writeValue(Data(value), for: characteristic, type: .withResponse)
    }
}

// MARK: - Internal
extension DroidConnector {
    
    var characteristics: [Characteristic] {
        scanData?
            .peripheral
            .discoveredServices?
            .compactMap(\.discoveredCharacteristics)
            .flatMap { $0 } ?? []
    }
    
    func getCharacteristic(from type: DroidBLE) -> Characteristic? {
        characteristics.first { $0.uuid.uuidString.lowercased() == type.rawValue }
    }
    
    func rawData(command: UInt8, payload: [UInt8]) -> [UInt8] {
        var rawData: [UInt8] = .init(repeating: 0, count: payload.count + 4)
        let crc = generateChecksumCRC16(bytes: payload)
        
        rawData[0] = UInt8((command << 1) | (UInt8((payload.count & 256)) >> 8))
        rawData[1] = UInt8(payload.count & 255)
        
        for (n, item) in payload.enumerated() {
            rawData[n + 2] = item
        }
        
        rawData[rawData.count - 1] = UInt8(crc & 255)
        rawData[rawData.count - 2] = UInt8((crc & 65280) >> 8)
        
        return rawData
    }
    
    func generateChecksumCRC16(bytes: [UInt8]) -> Int {
        var bit = false, c15 = false, crc = 65535
        
        for b in bytes {
            for i in 0..<8 {
                bit = ((b >> (7 - i)) & 1) == 1
                c15 = ((crc >> 15) & 1) == 1
                crc <<= 1;
                
                if c15 != bit {
                    crc ^= 4129
                }
            }
        }
        return crc & 65535
    }
}
