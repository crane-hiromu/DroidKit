//
//  DroidInput.swift
//  Droid
//
//  Created by hcrane on 2022/09/14.
//

import Foundation

// MARK: - Protocol
public protocol DroidInputProtocol: AnyObject {
    var rawInput: UInt8 { get set }
}

// MARK: - Class
public final class DroidInput: NSObject, DroidInputProtocol {
    var onChange: (() -> Void)?
    var onStateChange: (() -> Void)?
    
    public var rawInput: UInt8 = 0 {
        didSet {
            if oldValue != rawInput {
                onChange?()
            }
            
            if (oldValue < 128 && 128 < rawInput) || (128 < oldValue && rawInput < 128) {
                onStateChange?()
            }
        }
    }
    
    public var isOn: Bool {
        return 128 < rawInput
    }
    
    public var value: Double {
        return Double(rawInput) / 255
    }
    
    public func onValueChange(_ action: (() -> Void)?) {
        onChange = action
    }
    
    public func onStateChange(_ action: (() -> Void)?) {
        onStateChange = action
    }
}
