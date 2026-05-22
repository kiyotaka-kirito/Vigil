//
//  BudgetRepository.swift
//  VigilCore
//
//  Created by Kiyotaka Kirito on 22/05/2026.
//

import Foundation

public protocol BudgetRepository {
    func fetchAll() throws -> [Budget]
    func upsert(_ budget: Budget) throws
    func delete(id: UUID) throws
}
