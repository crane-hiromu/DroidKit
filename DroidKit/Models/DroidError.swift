//
//  DroidError.swift
//  
//
//  Created by h.crane on 2022/09/16.
//

import Foundation

// MARK: - Error Type
enum DroidError: Error, LocalizedError {
    case noScanData
    case noDiscoverServices
    case noCharacteristic
    case noBluetoothType
    
    var errorDescription: String? {
        switch self {
        case .noScanData: return "Can not find scan data"
        case .noDiscoverServices: return "Can not discover services"
        case .noCharacteristic: return "Can not find characteristic"
        case .noBluetoothType: return "Can not match bluetooth id"
        }
    }
    
    // fixme
    var recoverySuggestion: String? {
        switch self {
        case .noScanData: return "Please try again"
        case .noDiscoverServices: return "Please try again"
        case .noCharacteristic: return "Please try again"
        case .noBluetoothType: return "Please try again"
        }
    }
}
