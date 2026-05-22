//
//  TransactionRepository.swift
//  VigilCore
//
//  Created by Kiyotaka Kirito on 22/05/2026.
//

import Foundation

public protocol TransactionRepository {
    func fetchAll() throws -> [Transaction]
    func add(_ transaction: Transaction) throws
    func delete(id: UUID) throws
    
}
