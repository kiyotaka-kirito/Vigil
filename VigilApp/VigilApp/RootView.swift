//
//  RootView.swift
//  VigilApp
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import SwiftUI
import VigilFeatures

struct RootView: View {
    
    let dashboardVM: DashboardViewModel
    let transactionListVM: TransactionListViewModel
    let budgetListVM: BudgetListViewModel
    let chartVM: ChartViewModel
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(viewModel: dashboardVM)
                .tabItem { Label("Dashboard", systemImage: "house.fill") }
                .tag(0)
            
            TransactionListView(viewModel: transactionListVM)
                .tabItem { Label("Transactions", systemImage: "list.bullet") }
                .tag(1)
            
            BudgetListView(viewModel: budgetListVM)
                .tabItem { Label("Budgets", systemImage: "sterlingsign.gauge.chart.lefthalf.righthalf") }
                .tag(2)
            
            ChartView(viewModel: chartVM)
                .tabItem { Label("Charts", systemImage: "chart.pie.fill") }
                .tag(3)
        }
    }
}

