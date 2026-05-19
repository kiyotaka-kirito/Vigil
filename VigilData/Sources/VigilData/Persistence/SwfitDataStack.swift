//
//  File.swift
//  VigilData
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import Foundation
import SwiftData

@MainActor
public final class SwfitDataStack {
    
    private static let shard = SwfitDataStack()
    
    public let container: ModelContainer
    
    public init() {
        let schema = Schema([
            TransactionDTO.self,
            BudgetDTO.self
        ])
        
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            container = try ModelContainer(
                for: schema,
                configurations: config
            )
        } catch {
            fatalError("SwiftData failed to start: \(error)")
        }
    }
}
