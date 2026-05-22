//
//  Transaction.swift
//  VigilCore
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import Foundation

public struct Transaction: Identifiable {
    
    public let id: UUID
    public let amount: Double
    public let category: Category
    public let date: Date
    public let note: String
    
    public init(
        id: UUID = UUID(),
        amount: Double,
        category: Category,
        date: Date = Date(),
        note: String = ""
    ) {
        self.id         = id
        self.amount     = amount
        self.category   = category
        self.date       = date
        self.note       = note
    }
}
