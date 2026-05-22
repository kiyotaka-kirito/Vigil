//
//  TransactionRow.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import SwiftUI
import VigilCore

public struct TransactionRow: View {
    
    public let transaction: VigilCore.Transaction
    
    public init(transaction: VigilCore.Transaction) {
        self.transaction = transaction
    }
    
    public var body: some View {
        HStack(spacing: 14) {
            // Category Icon
            Text(transaction.category.icon)
                .font(.title2)
                .frame(width: 48, height: 48)
                .background(Color(.systemGray6))
                .clipShape(Circle())
            
            // Note and Date
            VStack(alignment: .leading, spacing: 3) {
                Text(transaction.note.isEmpty
                     ? transaction.category.rawValue
                     : transaction.note )
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Amount
            Text("$\(transaction.amount, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.red)
            
        }
        .padding(.vertical, 4)
    }
    
}

#Preview {
    TransactionRow(transaction: Transaction(amount: 10.0, category: .shopping, date: Date()))
}
