//
//  VigilAppApp.swift
//  VigilApp
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import SwiftUI
import SwiftData
import VigilData
import VigilFeatures

@main
struct VigilAppApp: App {
    
    let stack = SwfitDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            let context             = stack.container.mainContext
            
            let transactionRepo     = TransactionRepositoryImpl(context: context)
            let budgetRepo          = BudgetRepositoryImpl(context: context)
            
            let dashboardVM         = DashboardViewModel(repository: transactionRepo)
            let transactionListVM   = TransactionListViewModel(repoistory: transactionRepo)
            let budgetListVM        = BudgetListViewModel(budgetRepository: budgetRepo, transactionRepository: transactionRepo)
            let chartVM             = ChartViewModel(repository: transactionRepo)
            
            RootView(
                dashboardVM: dashboardVM,
                transactionListVM: transactionListVM,
                budgetListVM: budgetListVM,
                chartVM: chartVM
            )
        }
    }
}
