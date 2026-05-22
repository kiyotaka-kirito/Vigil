//
//  ChartViewModelTests.swift
//  VigilFeaturesTests
//
//  Created by Kiyotaka Kirito on 22/05/2026.
//

import Testing
import VigilCore
@testable import VigilFeatures

@Suite("ChartViewModel")
struct ChartViewModelTests {
    
    func makeSUT(transactions: [Transaction] = [])
    -> (ChartViewModel, MockTransactionRepository) {
        let repo = MockTransactionRepository()
        repo.storedTransactions = transactions
        let vm = ChartViewModel(repository: repo)
        return (vm, repo)
    }
    
    @Test("groups transactions by category")
    func groupsByCategory() {
        let transactions = [
            Transaction(amount: 50,  category: .food),
            Transaction(amount: 30,  category: .food),
            Transaction(amount: 100, category: .transport)
        ]
        let (vm, _) = makeSUT(transactions: transactions)
        vm.load()
        
        #expect(vm.categorySpending.count == 2)
        
        let food = vm.categorySpending.first { $0.category == .food }
        #expect(food?.total == 80)
        
        let transport = vm.categorySpending.first(where: { $0.category == .transport })
        #expect(transport?.total == 100)
    }
    
    @Test("calculates totalSpent correctly")
    func calculatesTotalSpent() {
        let transactions = [
            Transaction(amount: 40,  category: .food),
            Transaction(amount: 60,  category: .health)
        ]
        let (vm, _) = makeSUT(transactions: transactions)
        vm.load()
        
        #expect(vm.totalSpent == 100)
    }
    
    @Test("calculates percentage correctly")
    func calculatesPercentage() {
        let transactions = [
            Transaction(amount: 75, category: .food),
            Transaction(amount: 25, category: .transport)
        ]
        let (vm, _) = makeSUT(transactions: transactions)
        vm.load()
        
        let food = vm.categorySpending.first { $0.category == .food }
        #expect(food?.percentage == 75.0)
        
        let transport = vm.categorySpending.first(where: { $0.category == .transport })
        #expect(transport?.percentage == 25.0)
    }
    
    @Test("empty transactions gives zero total")
    func emptyTransactionsGivesZeroTotal() {
        let (vm, _) = makeSUT(transactions: [])
        vm.load()

        #expect(vm.totalSpent == 0)
        #expect(vm.categorySpending.isEmpty)
    }
    
    @Test("shows error when repository throws")
    func showsErrorOnFailure() {
        let (vm, repo) = makeSUT()
        repo.shouldThrow = true
        vm.load()

        #expect(vm.errorMessage != nil)
        #expect(vm.categorySpending.isEmpty)
    }
}
