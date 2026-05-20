//
//  Budget.swift
//  VigilCore
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import Foundation

public struct Budget: Identifiable {
    
    public let id: UUID
    public let category: Category
    public let monthlyLimit: Double
    public var amountSpent: Double
    
    public init(
        id: UUID = UUID(),
        category: Category,
        monthlyLimit: Double,
        amountSpent: Double = 0
    ) {
        self.id             = id
        self.category       = category
        self.monthlyLimit   = monthlyLimit
        self.amountSpent    = amountSpent
    }
    
    public var remaining: Double {
        monthlyLimit - amountSpent
    }
    
    public var isOverBudget: Bool {
        amountSpent > monthlyLimit
    }
}
