//
//  DashboardViewModel.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import Foundation
import VigilCore
import VigilData
import Observation

@Observable
public final class DashboardViewModel {
    
    public var transactions: [Transaction]  = []
    public var isLoading: Bool              = false
    public var errorMessage: String?        = nil
    
    public var totalSpent: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    public var recentTransactions: [Transaction] {
        Array(transactions.prefix(5))
    }
    
    private let repository: TransactionRepositoryImpl
    
    public init(repository: TransactionRepositoryImpl) {
        self.repository = repository
    }
    
    public func loadTransactions() {
        isLoading       = true
        errorMessage    = nil
        
        do {
            transactions = try repository.fetchAll()
        } catch {
            errorMessage = "Failed to load transactions."
        }
        
        isLoading   = false
    }
    
}
