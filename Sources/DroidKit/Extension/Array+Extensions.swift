//
//  Array+Extensions.swift
//  
//
//  Created by h.crane on 2022/09/18.
//

import Foundation

// MARK: - Extension
extension Array where Element == UInt8 {
    
    /// Calculates the CRC over given range of bytes from the block of data
    /// https://github.com/NordicSemiconductor/Android-BLE-Common-Library/blob/c078e2579fe5c0b6d29d70cd9fc9614ac7c0d355/ble-common/src/main/java/no/nordicsemi/android/ble/common/util/CRC16.java#L167
    var asCRC16: Int {
        var bit = false, c15 = false, crc = 65535
        
        for b in self {
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
