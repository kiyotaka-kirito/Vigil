//
//  BudgetRepositoryImpl.swift
//  VigilData
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import Foundation
import SwiftData
import VigilCore

public final class BudgetRepositoryImpl {
    
    private let context: ModelContext
    
    public init(context: ModelContext) {
        self.context = context
    }
    
    public func fetchAll() throws -> [Budget] {
        let descriptor = FetchDescriptor<BudgetDTO>()
        let dtos = try context.fetch(descriptor)
        return dtos.map { $0.toDomain }
    }
    
    public func upsert(_ budget: Budget) throws {
        let descriptor = FetchDescriptor<BudgetDTO>()
        let all = try context.fetch(descriptor)
        
        if let existing = all.first(where: {
            $0.categoryRaw == budget.category.rawValue
        }) {
            existing.monthlyLimit = budget.monthlyLimit
            existing.amountSpent = budget.amountSpent
        } else {
            let dto = BudgetDTO(from: budget)
            context.insert(dto)
        }
        
        try context.save()
    }
}
