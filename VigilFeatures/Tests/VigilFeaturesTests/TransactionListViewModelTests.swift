//
//  TransactionListViewModelTests.swift
//  VigilFeaturesTests
//
//  Created by Kiyotaka Kirito on 22/05/2026.
//

import Testing
import VigilCore
@testable import VigilFeatures

@Suite("TransactionListViewModel")
struct TransactionListViewModelTests {
    
    func makeSUT(transactions: [Transaction] = [])
    -> (TransactionListViewModel, MockTransactionRepository) {
        let repo = MockTransactionRepository()
        repo.storedTransactions = transactions
        let vm = TransactionListViewModel(repoistory: repo)
        return (vm, repo)
    }
    
    // Transaction List
    @Test("loads all transactions")
    func loadsAllTransactions() {
        let transactions = [
            Transaction(amount: 20, category: .food),
            Transaction(amount: 15, category: .health)
        ]
        let (vm, _) = makeSUT(transactions: transactions)
        vm.load()

        #expect(vm.transactions.count == 2)
    }
    
    @Test("deletes transaction by id")
    func deletesTransaction() {
        let tx1 = Transaction(amount: 20, category: .food)
        let tx2 = Transaction(amount: 15, category: .health)
        let (vm, _) = makeSUT(transactions: [tx1, tx2])
        vm.load()

        // Delete the first one
        vm.delete(id: tx1.id)

        // Only tx2 should remain
        #expect(vm.transactions.count == 1)
        #expect(vm.transactions.first?.id == tx2.id)
    }
    
    @Test("delete updates local array immediately")
    func deleteUpdatesLocalArray() {
        let tx = Transaction(amount: 99, category: .shopping)
        let (vm, _) = makeSUT(transactions: [tx])
        vm.load()

        vm.delete(id: tx.id)

        #expect(vm.transactions.isEmpty)
    }
    
    @Test("shows error when load fails")
    func showsErrorOnLoadFailure() {
        let (vm, repo) = makeSUT()
        repo.shouldThrow = true
        vm.load()

        #expect(vm.errorMessage != nil)
    }
    
    @Test("shows error when delete fails")
    func showsErrorOnDeleteFailure() {
        let tx = Transaction(amount: 10, category: .food)
        let (vm, repo) = makeSUT(transactions: [tx])
        vm.load()

        repo.shouldThrow = true
        vm.delete(id: tx.id)

        #expect(vm.errorMessage != nil)
    }
    
    // Add Transaction
    @Test("saves valid transaction successfully")
    func savesValidTransaction() {
        let (vm, repo) = makeSUT()
        vm.amountText = "42.50"
        vm.selectedCategory = .food
        vm.note = "Dinner"
        
        vm.save()
        
        #expect(vm.didSaveSuccessfully == true)
        #expect(vm.errorMessage == nil)
        #expect(repo.addTransactions.count == 1)
        #expect(repo.addTransactions.first?.amount == 42.50)
        #expect(repo.addTransactions.first?.category == .food)
        #expect(repo.addTransactions.first?.note == "Dinner")
    }
    
    @Test("rejects empty amount")
    func rejectsEmptyAmount() {
        let (vm, repo) = makeSUT()
        vm.amountText = ""
        
        vm.save()
        
        #expect(vm.didSaveSuccessfully == false)
        #expect(vm.errorMessage != nil)
        #expect(repo.addTransactions.isEmpty)
    }
    
    @Test("rejects zero amount")
    func rejectsZeroAmount() {
        let (vm, _) = makeSUT()
        vm.amountText = "0"
        
        vm.save()
        
        #expect(vm.didSaveSuccessfully == false)
        #expect(vm.errorMessage != nil)
    }
    
    @Test("rejects non-numeric amount")
    func rejectsNonNumericAmount() {
        let (vm, repo) = makeSUT()
        vm.amountText = "abc"

        vm.save()

        #expect(vm.didSaveSuccessfully == false)
        #expect(repo.addTransactions.isEmpty)
    }
    
    @Test("shows error when repository throws")
    func showsErrorOnSaveFailure() {
        let (vm, repo) = makeSUT()
        vm.amountText = "50"
        repo.shouldThrow = true

        vm.save()

        #expect(vm.didSaveSuccessfully == false)
        #expect(vm.errorMessage != nil)
    }
    
    @Test("saves correct category")
    func savesCorrectCategory() {
        let (vm, repo) = makeSUT()
        vm.amountText = "25"
        vm.selectedCategory = .entertainment

        vm.save()

        #expect(repo.addTransactions.first?.category == .entertainment)
    }
}
