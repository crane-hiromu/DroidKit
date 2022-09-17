//
//  File.swift
//  File
//
//  Created by hcrane on 2022/09/14.
//

import Foundation
import CoreBluetooth

// MARK: - Protocol
public protocol BluetoothManagerProtocol: AnyObject {
    var onConnect: (() -> Void)? { get set }
    var onDisconnect: (() -> Void)? { get set }
    var onScan: (() -> Void)? { get set }
    func search()
    func sendCommand(id: UInt8, payload: [UInt8])
}

// MARK: - Manager
public final class BluetoothManager: NSObject, BluetoothManagerProtocol {
    
    // MARK: Singleton
    
    public static let `default` = BluetoothManager(droidInput: DroidInput())
    
    public init(droidInput: DroidInputProtocol) {
        self.droidInput = droidInput
    }
    
    // MARK: Property
    
    public var droidInput: DroidInputProtocol

    public var onConnect: (() -> Void)?
    public var onDisconnect: (() -> Void)?
    public var onScan: (() -> Void)?
    
    public var centralManager: CBCentralManager?
    
    public var bitSnapCharacteristics: CBCharacteristic?
    public var boardControlCharacteristics: CBCharacteristic?
    public var controlHub: CBPeripheral?
    
    public func search() {
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue(label: "sg.tk.droid.ble", qos: .userInitiated))
        
        centralManager?.delegate = self
        
//        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [self] _ in
//            sendCommand(id: 12, payload: [])
//        }
    }
}
