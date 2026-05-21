//
//  DashboardView.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import SwiftUI
import VigilCore

public struct DashboardView: View {
    
    @State var viewModel: DashboardViewModel

    public init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Total Spent Card
                    VStack(spacing: 8) {
                        Text("Total Spent this Month")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("$\(viewModel.totalSpent, specifier: "%.2f")")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Color(.systemIndigo).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    
                    // Recent Transactions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Transactions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else if viewModel.recentTransactions.isEmpty {
                            Text("No transactions yet")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            ForEach(viewModel.recentTransactions) { tx in
                                TransactionRow(transaction: tx)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                }
                .padding(.top)
            }
            .navigationTitle("Vigil")
            .onAppear { viewModel.loadTransactions() }
        }
        
    }
    
}

//#Preview {
//    DashboardView()
//}
