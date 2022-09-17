//
//  DroidCommand.swift
//  
//
//  Created by h.tsuruta on 2022/09/17.
//

import Foundation

// MARK: - Command Type
enum DroidCommand: UInt8 {
    case changeLEDColor = 9
    case moveWheel = 10
    case playSound = 15
}
