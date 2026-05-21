//
//  TransactionDTO.swift
//  VigilData
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import Foundation
import SwiftData
import VigilCore

@Model
public final class TransactionDTO {
    
    public var id: UUID
    public var amount: Double
    public var catgoryRaw: String
    public var date: Date
    public var note: String
    
    public init(from transaction: Transaction) {
        self.id         = transaction.id
        self.amount     = transaction.amount
        self.catgoryRaw = transaction.catgory.rawValue
        self.date       = transaction.date
        self.note       = transaction.note
    }
    
    public var toDomain: Transaction {
        Transaction(
            id: id,
            amount: amount,
            catgory: Category(rawValue: catgoryRaw) ?? .other,
            date: date,
            note: note
        )
    }
}
