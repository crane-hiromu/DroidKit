//
//  Shared+CBPeripheralDelegate.swift
//  DroidKit
//
//  Created by JiaChen(: on 1/9/21.
//

import CoreBluetooth

// MARK: - CBPeripheralDelegate
extension BluetoothManager: CBPeripheralDelegate {

    public func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?
    ) {
        guard let service = peripheral.services?.first else { return }
        
        let types: [BLEType] = [
            .W32_AUDIO_UPLOAD_CHARACTERISTIC,
            .W32_BITSNAP_CHARACTERISTIC,
            .W32_BOARD_CONTROL_CHARACTERISTIC
        ]
        let ids = types.map(\.uuid)
        
        peripheral.discoverCharacteristics(ids, for: service)
    }
    
    public func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    ) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            peripheral.discoverDescriptors(for: characteristic) // 動作している？
            
            debugPrint("----", characteristic.uuid.uuidString)
            
            switch BLEType(rawValue: characteristic.uuid.uuidString.lowercased()) {
            case .W32_BITSNAP_CHARACTERISTIC:
                debugPrint("----1")
                bitSnapCharacteristics = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                
            case .W32_BOARD_CONTROL_CHARACTERISTIC:
                debugPrint("----2")
                boardControlCharacteristics = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                
            default:
                debugPrint("----3")
                break
            }
        }
        
        let dispatchQueue = DispatchQueue(label: "sg.tk.droid.commands", qos: .userInitiated, autoreleaseFrequency: .never)
        
        dispatchQueue.async { [self] in
            onConnect?()
        }
    }
    
    public func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateNotificationStateFor characteristic: CBCharacteristic,
        error: Error?)
    {
        debugPrint("----", #function, error)
    }
    
    public func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        guard let value = characteristic.value else { return }
        let input = value.map({ UInt8($0) })
        
        // Check length and CMD code
        if input.count >= 5 && input[0] == 24 {
            let payload = Array(input[2..<input.count - 2])
            let crc = generateChecksumCRC16(bytes: payload)
            
            if input[input.count - 1] == UInt8(crc & 255) && input[input.count - 2] == UInt8((crc & 65280) >> 8) {
                droidInput.rawInput = payload.last!
            }
        }
    }
}

extension BluetoothManager {
    
    public func sendCommand(id: UInt8, payload: [UInt8]) {
        let data = rawData(command: id, payload: payload)
        
        if let characteristic = bitSnapCharacteristics {
            controlHub?.writeValue(Data(data), for: characteristic, type: .withResponse)
        }
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
        var bit = false
        var c15 = false
        var crc = 65535
        
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
