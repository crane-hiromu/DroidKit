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

// MARK: - Manager Protocol
protocol DroidManagerProtocol: AnyObject {
    var eventPublisher: AnyPublisher<CentralManagerEvent, Never> { get }
    func configure() async throws
    
    /// CentralManager Method
    func scan() async throws
    func connect() async throws
    func disconnect() async throws
    
    /// Peripheral Method
    func discoverServices() async throws
    func discoverCharacteristics() async throws
    func setNotifyValue(with characteristic: Characteristic) async throws
    func setNotifyValues() async throws
    func writeValue(with value: Data, and characteristic: Characteristic) async throws
    
    /// Command Method
    func go(at speed: Double) async throws
    func back(at speed: Double) async throws
    func turn(by degree: Double) async throws
    func stop(_ type: DroidWheel) async throws
    func changeLEDColor(to color: UIColor) async throws
    func playSound(_ type: DroidSound) async throws
    func wait(for seconds: TimeInterval)
}

// MARK: - Manager
final class DroidManager {
    
    // MARK: Singleton
    
    static let `default` = DroidManager()
    private init() {}
    
    // MARK: Property
    
    private let centralManager = CentralManager()
    private var scanData: ScanData?
}

// MARK: - DroidManagerProtocol
extension DroidManager: DroidManagerProtocol {
    
    var eventPublisher: AnyPublisher<CentralManagerEvent, Never> {
        centralManager.eventPublisher
    }
    
    func configure() async throws {
        try await scan()
        try await connect()
        try await discoverServices()
        try await discoverCharacteristics()
        try await setNotifyValues()
    }
    
    // MARK: CentralManager Method
    
    func scan() async throws {
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
    
    func connect() async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        try await centralManager.connect(data.peripheral)
    }
    
    func disconnect() async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        try await centralManager.cancelPeripheralConnection(data.peripheral)
    }
    
    // MARK: Peripheral Method
    
    func discoverServices() async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        let ids = [DroidBLE.UUID_W32_SERVICE.uuid]
        try await data.peripheral.discoverServices(ids)
    }
    
    func discoverCharacteristics() async throws {
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
    
    func setNotifyValue(with characteristic: Characteristic) async throws {
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
    
    func setNotifyValues() async throws {
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
    
    func writeValue(with value: Data, and characteristic: Characteristic) async throws {
        guard let data = scanData else {
            throw DroidError.noScanData
        }
        try await data.peripheral.writeValue(value, for: characteristic, type: .withResponse)
    }
    
    // MARK: Command Method
    
    /// move forward
    func go(at speed: Double) async throws {
        guard 0...1 ~= speed else { return }
        let payload = [DroidWheel.move.rawValue, DroidWheelOption.go(speed: speed).value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// move back
    func back(at speed: Double) async throws {
        guard 0...1 ~= speed else { return }
        let payload = [DroidWheel.move.rawValue, DroidWheelOption.back(speed: speed).value]
        try await action(command: .moveWheel, payload: payload)
    }
    
    /// turn towards
    /// - right: 0~90
    /// - left: 90~180
    func turn(by degree: Double) async throws {
        guard 0...180 ~= degree else { return }
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
    
    func wait(for seconds: TimeInterval) {
        Thread.sleep(forTimeInterval: seconds)
    }
}

// MARK: - Private
private extension DroidManager {
    
    var characteristics: [Characteristic] {
        scanData?
            .peripheral
            .discoveredServices?
            .compactMap(\.discoveredCharacteristics)
            .flatMap { $0 } ?? []
    }
    
    func action(command: DroidCommand, payload: [UInt8]) async throws {
        guard let characteristic = getCharacteristic(from: .W32_BITSNAP_CHARACTERISTIC) else {
            throw DroidError.noCharacteristic
        }
        let rawData = rawData(command: command, payload: payload)
        try await writeValue(with: Data(rawData), and: characteristic)
    }
    
    func getCharacteristic(from type: DroidBLE) -> Characteristic? {
        characteristics.first { $0.uuid.uuidString.lowercased() == type.rawValue }
    }
    
    func rawData(command: DroidCommand, payload: [UInt8]) -> [UInt8] {
        var rawData: [UInt8] = .init(repeating: 0, count: payload.count + 4)
        let crc = generateChecksumCRC16(bytes: payload)
        
        rawData[0] = UInt8((command.rawValue << 1) | (UInt8((payload.count & 256)) >> 8))
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
