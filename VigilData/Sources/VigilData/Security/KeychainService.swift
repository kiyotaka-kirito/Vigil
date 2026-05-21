//
//  KeychainService.swift
//  VigilData
//
//  Created by Kiyotaka Kirito on 21/05/2026.
//

import Foundation
import Security

@MainActor
public final class KeychainService {
    
    public static let shared = KeychainService()
    private init() {}
    
    private let pinKey = "com.vigilapp.pin"
    
    public func savePIN(_ pin: String) -> Bool {
        guard let data = pin.data(using: .utf8) else { return false }
        
        deletePIN()
        
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      pinKey,
            kSecValueData as String:        data,
            kSecAttrAccessible as String:   kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    public func loadPIN() -> String? {
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      pinKey,
            kSecReturnData as String:       true,
            kSecMatchLimit as String:       kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let pin = String(data: data, encoding: .utf8)
        else { return nil }
        
        return pin
    }
    
    @discardableResult
    public func deletePIN() -> Bool {
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      pinKey,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    public var hasPIN: Bool {
        loadPIN() != nil
    }
}
