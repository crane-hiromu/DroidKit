//
//  File.swift
//  File
//
//  Created by JiaChen(: on 1/9/21.
//

import Foundation
import CoreBluetooth

extension BluetoothManager: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(
        _ central: CBCentralManager
    ) {
        debugPrint("Updated")
        switch centralManager?.state {
        case .poweredOn:
            centralManager?.scanForPeripherals(withServices: [BLEType.UUID_W32_SERVICE.uuid])
            onScan?()
            
        case .some, .none:
           break
        }
    }
    
    public func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        debugPrint("Connected")
        peripheral.delegate = self
        peripheral.discoverServices([BLEType.UUID_W32_SERVICE.uuid])
    }
    
    public func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        debugPrint("Discovered")
        controlHub = peripheral
        centralManager?.connect(peripheral)
    }
    
    public func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    ) {
        debugPrint("Disconnected")
        onDisconnect?()
    }
}
