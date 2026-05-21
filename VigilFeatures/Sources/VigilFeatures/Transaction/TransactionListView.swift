//
//  TransactionListView.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import SwiftUI
import VigilCore

public struct TransactionListView: View {
    
    var viewModel: TransactionListViewModel
    @State var showingAddTransaction: Bool = false
    
    public init(viewModel: TransactionListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.transactions.isEmpty {
                    ContentUnavailableView(
                        "No Transactions",
                        systemImage: "tray",
                        description: Text("Add your first transaction.")
                    )
                } else {
                    List {
                        ForEach(viewModel.transactions) { tx in
                            TransactionRow(transaction: tx)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let id = viewModel.transactions[index].id
                                viewModel.delete(id: id)
                            }
                        }
                        
                    }
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                Button { showingAddTransaction = true } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionSheet(viewModel: viewModel)
            }
            .onAppear { viewModel.load() }
        }
    }
}

// MARK: - Sheet
struct AddTransactionSheet: View {
    
    @Bindable var viewModel: TransactionListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // Amount
                Section("Amount") {
                    TextField("0.00", text: $viewModel.amountText)
                        .keyboardType(.decimalPad)
                }
                
                // Category picker
                Section("Category") {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(Category.allCases) { category in
                            Text("\(category.icon) \(category.rawValue)")
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // Date
                Section("Date") {
                    DatePicker(
                        "Date",
                        selection: $viewModel.date,
                        displayedComponents: .date
                    )
                }
                
                // Note
                Section("Note (optional)") {
                    TextField("e.g. Lunch with team", text: $viewModel.note)
                }
                
                // Error message
                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { viewModel.save() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onChange(of: viewModel.didSaveSuccessfully) {
                if viewModel.didSaveSuccessfully {
                    dismiss()
                    viewModel.clear()
                }
            }
        }
    }
}
