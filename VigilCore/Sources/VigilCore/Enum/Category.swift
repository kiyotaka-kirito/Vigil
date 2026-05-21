//
//  Category.swift
//  VigilCore
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import Foundation

public enum Category: String, Identifiable, CaseIterable {
    
    case food               = "Food"
    case transport          = "Transport"
    case utilities          = "Utilities"
    case shopping           = "Shopping"
    case health             = "Health"
    case entertainment      = "Entertainment"
    case other              = "Other"

    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .food:          return "🍔"
        case .transport:     return "🚗"
        case .utilities:     return "💡"
        case .shopping:      return "🛍️"
        case .health:        return "❤️"
        case .entertainment: return "🎬"
        case .other:         return "📦"
        }
    }
}
