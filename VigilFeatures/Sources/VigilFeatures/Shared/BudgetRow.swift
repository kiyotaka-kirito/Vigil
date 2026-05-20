//
//  BudgetRow.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 20/05/2026.
//

import SwiftUI
import VigilCore

public struct BudgetRow: View {
    
    public let budget: Budget
    
    public init(budget: Budget) {
        self.budget = budget
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(budget.category.icon) \(budget.category.rawValue)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text("$\(budget.amountSpent, specifier: "%.0f") - $\(budget.monthlyLimit, specifier: "%.0f")")
                    .font(.caption)
                    .foregroundStyle(budget.isOverBudget ? .red : .secondary)
            }
            
            ProgressView(
                value: min(budget.amountSpent, budget.monthlyLimit),
                total: budget.monthlyLimit
            )
            .tint(budget.isOverBudget ? .red : .indigo)
        }
        .padding(.vertical, 4)
    }
    
}

#Preview {
    BudgetRow(budget: Budget(category: .entertainment, monthlyLimit: 1000.00))
}
