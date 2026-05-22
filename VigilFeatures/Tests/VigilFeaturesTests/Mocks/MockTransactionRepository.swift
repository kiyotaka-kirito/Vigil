//
//  MockTransactionRepository.swift
//  VigilFeaturesTests
//
//  Created by Kiyotaka Kirito on 22/05/2026.
//

import Foundation
import VigilCore

final class MockTransactionRepository: TransactionRepository {
    
    var storedTransactions: [Transaction]   = []
    var shouldThrow: Bool                   = false
    var addTransactions: [Transaction]      = []
    var deleteIDs: [UUID]                   = []
    
    func fetchAll() throws -> [Transaction] {
        if shouldThrow {
            throw NSError(domain: "MockError", code: 1)
        }
        return storedTransactions
    }
    
    func add(_ transaction: Transaction) throws {
        if shouldThrow {
            throw NSError(domain: "MockError", code: 1)
        }
        storedTransactions.append(transaction)
        addTransactions.append(transaction)
    }
    
    func delete(id: UUID) throws {
        if shouldThrow {
            throw NSError(domain: "MockError", code: 1)
        }
        storedTransactions.removeAll(where: { $0.id == id })
        deleteIDs.append(id)
    }
    
}
