//
//  TransactionListViewModel.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import Foundation
import VigilCore
import VigilData
import Observation

@Observable
public final class TransactionListViewModel {
    
    public var transactions: [Transaction]          = []
    public var errorMessage: String?                = nil
    
    public var amountText: String                   = ""
    public var selectedCategory: VigilCore.Category = .food
    public var date: Date                           = Date()
    public var note: String                         = ""
    public var didSaveSuccessfully: Bool            = false
    
    private let repository: TransactionRepositoryImpl
    
    public init(repoistory: TransactionRepositoryImpl) {
        self.repository = repoistory
    }
    
    public func loadTransactions() {
        do {
            transactions = try repository.fetchAll()
        } catch {
            errorMessage = "Faild to load."
        }
    }
    
    public func delete(id: UUID) {
        do {
            try repository.delete(id: id)
            transactions.removeAll(where: { $0.id == id })
        } catch {
            errorMessage = "Failed to delete."
        }
    }
    
    public func save() {
        guard let amount = Double(amountText), amount > 0 else {
            errorMessage = "Please enter a valid amount"
            return
        }
        
        let transaction = Transaction(
            amount: amount,
            catgory: selectedCategory,
            date: date,
            note: note
        )
        
        do {
            try repository.add(transaction)
            didSaveSuccessfully = true
        } catch {
            errorMessage = "Failed to save transaction."
        }
    }
}
