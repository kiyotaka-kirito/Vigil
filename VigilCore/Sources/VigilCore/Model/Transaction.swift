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
    public let catgory: Category
    public let date: Date
    public let note: String
    
    public init(
        id: UUID = UUID(),
        amount: Double,
        catgory: Category,
        date: Date = Date(),
        note: String = ""
    ) {
        self.id         = id
        self.amount     = amount
        self.catgory    = catgory
        self.date       = date
        self.note       = note
    }
}
