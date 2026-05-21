//
//  LockState.swift
//  VigilCore
//
//  Created by Kiyotaka Kirito on 21/05/2026.
//

import Foundation

public enum LockState: Equatable {
    case unlocked
    case locked
    case lockedOut(until: Date)
}

public enum LockScreen: Equatable {
    case biometric
    case pin
    case setup
}
