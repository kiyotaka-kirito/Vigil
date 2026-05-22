//
//  BudgetListViewModel.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 20/05/2026.
//

import Foundation
import VigilCore
import VigilData
import Observation

@Observable
public final class BudgetListViewModel {
    
    public var budgets: [Budget]                    = []
    public var errorMessage: String?                = nil
    
    public var selectedCatgory: VigilCore.Category  = .food
    public var limitText: String                    = ""
    
    private let budgetRepository: BudgetRepository
    private let transactionRepository: TransactionRepository
    
    public init(
        budgetRepository: BudgetRepository,
        transactionRepository: TransactionRepository
    ) {
        self.budgetRepository = budgetRepository
        self.transactionRepository = transactionRepository
    }
    
    public func load() {
        do {
            let budgets = try budgetRepository.fetchAll()
            let transactions = try transactionRepository.fetchAll()
            
            self.budgets = budgets.map { budget in
                var updatedBudget = budget
                
                let spent = transactions
                    .filter { $0.catgory == updatedBudget.category }
                    .reduce(0) { $0 + $1.amount }
                
                updatedBudget.amountSpent = spent
                return updatedBudget
            }
        } catch {
            errorMessage = "Failed to load budgets."
        }
    }
    
    public func upsert(category: VigilCore.Category, limit: Double) {
        let budget = Budget(category: category, monthlyLimit: limit)
        
        do {
            try budgetRepository.upsert(budget)
            load()
        } catch {
            errorMessage = "Failed to save budget."
        }
    }
    
    public func delete(id: UUID) {
        do {
            try budgetRepository.delete(id: id)
            budgets.removeAll(where: { $0.id == id })
            load()
        } catch {
            errorMessage = "Failed to delete."
        }
    }
    
    public func clear() {
        selectedCatgory = .food
        limitText = ""
    }
}
