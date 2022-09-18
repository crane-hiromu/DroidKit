//
//  UIColor+Extensions.swift
//
//
//  Created by h.crane on 2022/09/17.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - Extension
extension UIColor {
    
    /// initialize with hex
    ///
    /// example
    /// UIColor(hex: 0xAABBCC)
    convenience init(hex: Int, alpha: Double = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / CGFloat(255.0)
        let g = CGFloat((hex & 0x00FF00) >> 8) / CGFloat(255.0)
        let b = CGFloat(hex & 0x0000FF) / CGFloat(255.0)
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    /// convert to RGB
    var asRGB: (red: UInt8, green: UInt8, blue: UInt8) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        red *= 255; green *= 255; blue *= 255;
        return (UInt8(red), UInt8(green), UInt8(blue))
    }
    
    /// convert to SwiftUI Color
    var asColor: Color {
        Color(self)
    }
}
