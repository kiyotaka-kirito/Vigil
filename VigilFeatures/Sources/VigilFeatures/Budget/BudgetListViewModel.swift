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
    
    private let budgetRepository: BudgetRepositoryImpl
    private let transactionRepository: TransactionRepositoryImpl
    
    public init(
        budgetRepository: BudgetRepositoryImpl,
        transactionRepository: TransactionRepositoryImpl
    ) {
        self.budgetRepository = budgetRepository
        self.transactionRepository = transactionRepository
    }
    
    public func load() {
        do {
            var budgets = try budgetRepository.fetchAll()
            let transactions = try transactionRepository.fetchAll()
            
            for index in budgets.indices {
                let category = transactions[index].catgory
                let spent = transactions
                    .filter { $0.catgory == category }
                    .reduce(0) { $0 + $1.amount }
                budgets[index].amountSpent = spent
            }
            
            self.budgets = budgets
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
}
