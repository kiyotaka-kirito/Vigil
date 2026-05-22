//
//  BudgetListView.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 20/05/2026.
//

import SwiftUI
import VigilCore

public struct BudgetListView: View {
    
    var viewModel: BudgetListViewModel
    @State var showingAddBudget: Bool = false
    
    public init(viewModel: BudgetListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.budgets.isEmpty {
                    ContentUnavailableView(
                        "No Budgets",
                        systemImage: "chart.pie",
                        description: Text("Tap + to set a monthly limit.")
                    )
                } else {
                    List {
                        ForEach(viewModel.budgets) { tx in
                            BudgetRow(budget: tx)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let id = viewModel.budgets[index].id
                                viewModel.delete(id: id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Budgets")
            .preferredColorScheme(.dark)
            .toolbar {
                Button { showingAddBudget = true } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetSheet(viewModel: viewModel)
            }
            .onAppear { viewModel.load() }
        }
    }
}

// MARK: - Sheet
struct AddBudgetSheet: View {
    
    @Bindable var viewModel: BudgetListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Category", selection: $viewModel.selectedCatgory) {
                    ForEach(Category.allCases) { cat in
                        Text("\(cat.icon) \(cat.rawValue)").tag(cat)
                    }
                }
                TextField("Monthly limit", text: $viewModel.limitText)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Set Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let limit = Double(viewModel.limitText), limit > 0 {
                            viewModel.upsert(
                                category: viewModel.selectedCatgory,
                                limit: limit
                            )
                            viewModel.clear()
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
