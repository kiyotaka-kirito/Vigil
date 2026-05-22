//
//  DashboardViewModelTests.swift
//  VigilFeaturesTests
//
//  Created by Kiyotaka Kirito on 22/05/2026.
//

import Testing
import VigilCore
@testable import VigilFeatures

@Suite("DashboardViewModel")
struct DashboardViewModelTests {

    func makeSUT(transactions: [Transaction] = [])
    -> (DashboardViewModel, MockTransactionRepository) {
        let repo = MockTransactionRepository()
        repo.storedTransactions = transactions
        let vm = DashboardViewModel(repository: repo)
        return (vm, repo)
    }

    @Test("loads transactions successfully")
    func loadsTransactions() {
        let transactions = [
            Transaction(amount: 50, category: .food),
            Transaction(amount: 30, category: .transport)
        ]
        let (vm, _) = makeSUT(transactions: transactions)

        vm.loadTransactions()

        // Assert — check the result
        #expect(vm.transactions.count == 2)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }
    
    @Test("calculates totalSpent correctly")
    func calculatesTotalSpent() {
        let transactions = [
            Transaction(amount: 100, category: .food),
            Transaction(amount: 50,  category: .transport),
            Transaction(amount: 25,  category: .utilities)
        ]
        let (vm, _) = makeSUT(transactions: transactions)
        vm.loadTransactions()
        
        #expect(vm.totalSpent == 175)
    }
    
    @Test("recentTransactions returns max 5")
    func recentTransactionsLimit() {
        let transactions = (1...7).map {
            Transaction(amount: Double($0), category: .food)
        }
        let (vm, _) = makeSUT(transactions: transactions)
        vm.loadTransactions()
        
        #expect(vm.recentTransactions.count == 5)
    }
    
    @Test("show error when repository throws")
    func showsErrorOnFailure() {
        let (vm, repo) = makeSUT()
        repo.shouldThrow = true
        
        vm.loadTransactions()
        
        #expect(vm.errorMessage != nil)
        #expect(vm.transactions.isEmpty)
    }
    
    @Test("empty transacations gives totalSpent of zero")
    func emptyTransactionsGivesZeroTotal() {
        let (vm, _) = makeSUT(transactions: [])
        vm.loadTransactions()
        
        #expect(vm.totalSpent == 0)
    }

}
