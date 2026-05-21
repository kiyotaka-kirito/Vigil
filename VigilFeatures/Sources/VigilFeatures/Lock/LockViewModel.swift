//
//  LockViewModel.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 21/05/2026.
//

import Foundation
import VigilCore
import VigilData
import LocalAuthentication
import Observation

@MainActor
@Observable
public final class LockViewModel {
    
    public var lockState: LockState             = .locked
    public var currentScreen: LockScreen        = .biometric
    public var pinInput: String                 = ""
    public var setupPIN: String                 = ""
    public var confirmPIN: String               = ""
    public var errorMessage: String?            = nil
    public var isSettingUp: Bool                = false
    
    private let maxAttempts                     = 3
    private let lockoutDuratin: TimeInterval    = 30
    private var failAttempts                    = 0
    
    private var backgroundedAt: Date?           = nil
    private var lockAfter: TimeInterval         = 60
    
    private let keychain = KeychainService.shared
    
    public init() {
        if !keychain.hasPIN {
            isSettingUp = true
            currentScreen = .setup
            lockState = .locked
        }
    }
    
    // Move to background
    public func appDidBackground() {
        backgroundedAt = Date()
    }
    
    // return to foreground
    public func appDidForeground() {
        guard lockState == .unlocked else { return }
        
        if let backgroundedAt,
           Date().timeIntervalSince(backgroundedAt) >= lockAfter {
            lock()
        }
        backgroundedAt = nil
    }
    
    // Lock the app
    public func lock() {
        pinInput = ""
        errorMessage = nil
        failAttempts = 0
        lockState = .locked
        currentScreen = .biometric
    }
    
    // Face ID / Touch ID
    public func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometrics are available
        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            // Device has no Face ID / Touch ID - go straight to PIN
            currentScreen = .pin
            return
        }
        
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Unlock Vigil"
        ) { success, _ in
            DispatchQueue.main.async {
                if success { self.lockState = .unlocked }
                else { self.currentScreen = .pin }
            }
            
        }
    }
    
    // PIN entry
    public func submitPIN() {
        guard PINValidator.isValid(pinInput) else {
            errorMessage = "Please enter a 4-digit PIN."
            return
        }
        
        guard let saved = keychain.loadPIN() else {
            errorMessage = "No PIN found. Please restart the app."
            return
        }
        
        if PINValidator.matches(pinInput, saved) {
            // Correct
            failAttempts = 0
            errorMessage = nil
            lockState = .unlocked
        } else {
            // Wrong
            failAttempts += 1
            pinInput = ""
            
            if failAttempts > maxAttempts {
                // Lock out - 30 sec
                let until = Date().addingTimeInterval(lockoutDuratin)
                lockState = .lockedOut(until: until)
                errorMessage = nil
            } else {
                let remaining = maxAttempts - failAttempts
                errorMessage = "Wrong PIN \(remaining) attempt\(remaining == 1 ? "" : "s") remaining."
            }
        }
    }
    
    // PIN digit input helper
    public func appendDigit(_ digit: String) {
        guard pinInput.count < PINValidator.pinLength else { return }
        pinInput += digit
    }
    
    public func deleteLastDigit() {
        guard !pinInput.isEmpty else { return }
        pinInput.removeLast()
    }
    
    // First-launch PIN setup
    public func submitSetupPIN() {
        guard PINValidator.isValid(setupPIN) else {
            errorMessage = "PIN must be exactly 4 digits."
            return
        }
        
        // Move to confrim step
        currentScreen = .pin
        isSettingUp = false
        confirmPIN = setupPIN
        setupPIN = ""
        pinInput = ""
        errorMessage = "Confirm your PIN."
    }
    
    public func confirmSetupPIN() {
        if PINValidator.matches(pinInput, confirmPIN) {
            _ = keychain.savePIN(pinInput)
            errorMessage = nil
            lockState = .unlocked
        } else {
            // Mismatch - start over
            pinInput = ""
            confirmPIN = ""
            currentScreen = .setup
            isSettingUp = true
            errorMessage = "PINs didn't match. Please try again."
        }
    }
    
}
