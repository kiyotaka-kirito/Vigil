//
//  RootView.swift
//  VigilApp
//
//  Created by Kiyotaka Kirito on 19/05/2026.
//

import SwiftUI
import VigilCore
import VigilFeatures

struct RootView: View {
    
    let dashboardVM: DashboardViewModel
    let transactionListVM: TransactionListViewModel
    let budgetListVM: BudgetListViewModel
    let chartVM: ChartViewModel
    
    @State private var viewModel = LockViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
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
            
            if viewModel.lockState != .unlocked {
                lockOverlay
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.easeIn(duration: 0.25), value: viewModel.lockState)
    }
    
    @ViewBuilder
    private var lockOverlay: some View {
        switch viewModel.lockState {
        case .lockedOut(let until):
            LockoutView(until: until) { viewModel.lock() }
            
        case .locked:
            switch viewModel.currentScreen {
            case .setup: PINSetupView(viewModel: viewModel)
            case .biometric: LockView(viewModel: viewModel)
            case .pin: PINEntryView(viewModel: viewModel)
            }
            
        case .unlocked:
            EmptyView()
        }
    }
}



