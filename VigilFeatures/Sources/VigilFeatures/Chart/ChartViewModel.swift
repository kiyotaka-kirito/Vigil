//
//  ChartViewModel.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 20/05/2026.
//

import Foundation
import VigilCore
import VigilData
import Observation

public struct CategorySpending: Identifiable {
    public let id = UUID()
    public let category: VigilCore.Category
    public let total: Double
    public let percentage: Double
}

public enum ChartType: String, CaseIterable {
    case pie = "Pie Chart"
    case bar = "Bar Chart"
}

@Observable
public final class ChartViewModel {
    
    public var categorySpending: [CategorySpending] = []
    public var totalSpent: Double                   = 0.0
    public var isLoading: Bool                      = false
    public var errorMessage: String?                = nil
    
    public var selectedChartType: ChartType         = .pie
    
    private let repository: TransactionRepositoryImpl
    
    public init(repository: TransactionRepositoryImpl) {
        self.repository = repository
    }
    
    public func load() {
        isLoading = true
        
        do {
            let transactions = try repository.fetchAll()
            
            var totals: [VigilCore.Category: Double] = [:]
            for tx in transactions {
                totals[tx.catgory, default: 0] += tx.amount
            }
            
            let grandTotal = totals.values.reduce(0, +)
            self.totalSpent = grandTotal
            
            self.categorySpending = totals
                .map { category, total in
                    CategorySpending(
                        category: category, total: total,
                        percentage: grandTotal > 0
                        ? (total / grandTotal) * 100
                        : 0
                    )
                }
                .sorted { $0.total > $1.total }
            
        } catch {
            errorMessage = "Failed to load chart data."
        }
    }
}
