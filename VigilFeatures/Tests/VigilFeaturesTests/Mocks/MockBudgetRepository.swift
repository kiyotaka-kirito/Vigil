//
//  MockBudgetRepository.swift
//  VigilFeaturesTests
//
//  Created by Kiyotaka Kirito on 22/05/2026.
//

import Foundation
import VigilCore
final class MockBudgetRepository: BudgetRepository {
    
    var storedBudgets: [Budget]     = []
    var shouldThrow: Bool           = false
    var upsertedBudgets: [Budget]   = []
    var deleteIDs: [UUID]           = []
    
    func fetchAll() throws -> [Budget] {
        if shouldThrow {
            throw NSError(domain: "MockError", code: 1)
        }
        return storedBudgets
    }
    
    func upsert(_ budget: Budget) throws {
        if shouldThrow {
            throw NSError(domain: "MockError", code: 1)
        }
        
        if let index = storedBudgets.firstIndex(
            where: { $0.category == budget.category }
        ) {
            storedBudgets[index] = budget
        } else {
            storedBudgets.append(budget)
        }
        upsertedBudgets.append(budget)
    }
    
    func delete(id: UUID) throws {
        if shouldThrow {
            throw NSError(domain: "MockError", code: 1)
        }
        storedBudgets.removeAll(where: { $0.id == id })
        deleteIDs.append(id)
    }
}
