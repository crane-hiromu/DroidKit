//
//  DroidSound.swift
//  
//
//  Created by h.crane on 2022/09/17.
//

import Foundation

/*
 Droid has 22 default sounds.
 */

// MARK: - Sound Type
public enum DroidSound: UInt8, CaseIterable, Hashable {
    case s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,
         s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21
}
