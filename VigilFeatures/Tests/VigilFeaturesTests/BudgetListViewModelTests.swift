//
//  BudgetListViewModelTests.swift
//  VigilFeaturesTests
//
//  Created by Kiyotaka Kirito on 22/05/2026.
//

import Testing
import VigilCore
@testable import VigilFeatures

@Suite("BudgetListViewModel")
struct BudgetListViewModelTests {
    
    func makeSUT(
        budgets: [Budget] = [],
        transactions: [Transaction] = []
    ) -> (BudgetListViewModel, MockBudgetRepository, MockTransactionRepository) {
        let budgetRepo                      = MockBudgetRepository()
        let transactionRepo                 = MockTransactionRepository()
        
        budgetRepo.storedBudgets            = budgets
        transactionRepo.storedTransactions  = transactions
        
        let vm = BudgetListViewModel(
            budgetRepository: budgetRepo,
            transactionRepository: transactionRepo
        )
        return (vm, budgetRepo, transactionRepo)
    }
    
    @Test("loads budgets successfully")
    func loadsBudgets() {
        let budgets = [
            Budget(category: .food,      monthlyLimit: 300),
            Budget(category: .transport, monthlyLimit: 150)
        ]
        let (vm, _, _) = makeSUT(budgets: budgets)
        vm.load()
        
        #expect(vm.budgets.count == 2)
        #expect(vm.errorMessage == nil)
    }
    
    @Test("calculates amountSpent per category")
    func calculatesAmountSpent() {
        let budgets = [Budget(category: .food, monthlyLimit: 300)]
        let transactions = [
            Transaction(amount: 50,  category: .food),
            Transaction(amount: 30,  category: .food),
            Transaction(amount: 100, category: .transport) // different category
        ]

        let (vm, _, _) = makeSUT(budgets: budgets, transactions: transactions)
        vm.load()
        
        #expect(vm.budgets.first?.amountSpent == 80)
    }
    
    @Test("upserts a new budget")
    func upsertsNewBudget() {
        let (vm, repo, _) = makeSUT()
        
        vm.upsert(category: .shopping, limit: 200)
        
        #expect(repo.upsertedBudgets.count == 1)
        #expect(repo.upsertedBudgets.first?.category == .shopping)
        #expect(repo.upsertedBudgets.first?.monthlyLimit == 200)
    }
    
    @Test("deletes budget by id")
    func deletesTransaction() {
        let tx1 = Budget(category: .food, monthlyLimit: 400)
        let tx2 = Budget(category: .entertainment, monthlyLimit: 200)
        let (vm, _, _) = makeSUT(budgets: [tx1, tx2])
        vm.load()

        // Delete the first one
        vm.delete(id: tx1.id)

        // Only tx2 should remain
        #expect(vm.budgets.count == 1)
        #expect(vm.budgets.first?.id == tx2.id)
    }
    
    @Test("delete updates local array immediately")
    func deleteUpdatesLocalArray() {
        let tx = Budget(category: .food, monthlyLimit: 500)
        let (vm, _, _) = makeSUT(budgets: [tx])
        vm.load()

        vm.delete(id: tx.id)

        #expect(vm.budgets.isEmpty)
    }
    
    @Test("isOverBudget is true when spending exceeds limit")
    func detectsOverBudget() {
        let budgets = [Budget(category: .food, monthlyLimit: 100)]
        let transactions = [
            Transaction(amount: 80,  category: .food),
            Transaction(amount: 60,  category: .food) 
        ]
        let (vm, _, _) = makeSUT(
            budgets: budgets,
            transactions: transactions
        )
        vm.load()

        #expect(vm.budgets.first?.isOverBudget == true)
    }

    @Test("shows error when load fails")
    func showsErrorOnFailure() {
        let (vm, repo, _) = makeSUT()
        repo.shouldThrow = true
        vm.load()

        #expect(vm.errorMessage != nil)
    }
}
