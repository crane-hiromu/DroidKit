//
//  DroidError.swift
//  
//
//  Created by h.tsuruta on 2022/09/16.
//

import Foundation

// MARK: - Error
enum DroidError: Error, LocalizedError {
    case noScanData
    case noDiscoverServices
    case noCharacteristic
    
    var errorDescription: String? {
        switch self {
        case .noScanData: return "Can not find scan data"
        case .noDiscoverServices: return "Can not discover services"
        case .noCharacteristic: return "Can not find characteristic"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .noScanData: return "Please try again"
        case .noDiscoverServices: return "Please try again"
        case .noCharacteristic: return "Please try again"
        }
    }
}
