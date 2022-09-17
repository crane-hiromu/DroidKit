//
//  DroidError.swift
//  
//
//  Created by h.crane on 2022/09/16.
//

import Foundation

// MARK: - Error Type
public enum DroidError: Error, LocalizedError {
    case noScanData
    case noDiscoverServices
    case noCharacteristic
    case noBluetoothType
    
    public var errorDescription: String? {
        switch self {
        case .noScanData: return "Can not find scan data"
        case .noDiscoverServices: return "Can not discover services"
        case .noCharacteristic: return "Can not find characteristic"
        case .noBluetoothType: return "Can not match bluetooth id"
        }
    }
    
    public var recoverySuggestion: String? {
        "Please try again"
    }
}
