//
//  DroidBLE.swift
//
//
//  Created by h.tsuruta on 2022/09/17.
//

import Foundation
import CoreBluetooth

// MARK: - BLE Type
enum DroidBLE: String {
    case UUID_W32_SERVICE = "d9d9e9e0-aa4e-4797-8151-cb41cedaf2ad"
    case W32_BITSNAP_CHARACTERISTIC = "d9d9e9e1-aa4e-4797-8151-cb41cedaf2ad"
    case W32_BOARD_CONTROL_CHARACTERISTIC = "d9d9e9e2-aa4e-4797-8151-cb41cedaf2ad"
    case W32_AUDIO_UPLOAD_CHARACTERISTIC = "d9d9e9e3-aa4e-4797-8151-cb41cedaf2ad"
    case CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"
    
    var uuid: CBUUID {
        .init(string: rawValue)
    }
    
    static let W32_CONTROL_HUB = "w32 ControlHub"
}
