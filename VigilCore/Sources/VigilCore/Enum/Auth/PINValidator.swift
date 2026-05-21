//
//  PINValidator.swift
//  VigilCore
//
//  Created by Kiyotaka Kirito on 21/05/2026.
//

import Foundation

public enum PINValidator {
    
    public static let pinLength = 4
    
    public static func isValid(_ pin: String) -> Bool {
        pin.count == pinLength && pin.allSatisfy(\.isNumber)
    }
    
    public static func matches(_ pin: String, _ other: String) -> Bool {
        pin == other
    }
}
