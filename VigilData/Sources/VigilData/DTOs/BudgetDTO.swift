//
//  BudgetDTO.swift
//  VigilData
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import Foundation
import SwiftData
import VigilCore

@Model
public final class BudgetDTO {
    
    public var id: UUID
    public var categoryRaw: String
    public var monthlyLimit: Double
    public var amountSpent: Double
    
    public init(from budget: Budget) {
        self.id             = budget.id
        self.categoryRaw    = budget.category.rawValue
        self.monthlyLimit   = budget.monthlyLimit
        self.amountSpent    = budget.amountSpent
    }
    
    public var toDomain: Budget {
        Budget(
            id: id,
            category: Category(rawValue: categoryRaw) ?? .other,
            monthlyLimit: monthlyLimit,
            amountSpent: amountSpent
        )
    }
    
}
