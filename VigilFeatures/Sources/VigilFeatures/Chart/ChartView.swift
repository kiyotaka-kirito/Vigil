//
//  ChartView.swift
//  VigilFeatures
//
//  Created by Kiyotaka Kirito on 20/05/2026.
//

import SwiftUI
import Charts
import VigilCore

public struct ChartView: View {
    
    @State var viewModel: ChartViewModel
    
    public init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Chart Picker
                    Picker("Chart Type", selection: $viewModel.selectedChartType) {
                        ForEach(ChartType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Chart Data
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(40)
                    } else if viewModel.categorySpending.isEmpty {
                        ContentUnavailableView(
                            "No Data",
                            systemImage: "chart.pie",
                            description: Text("Add transactions to see your spending breakdown.")
                        )
                    } else {
                        if viewModel.selectedChartType == .pie {
                            pieChart
                        } else {
                            barChart
                        }
                        
                        // Breakdown List
                        breakdownList
                        
                    }
                }
            }
            .navigationTitle("Spending")
            .onAppear { viewModel.load() }
        }
    }
    
    private var pieChart: some View {
        VStack(spacing: 16) {
            ZStack {
                // The Pie Chart
                Chart(viewModel.categorySpending) { item in
                    SectorMark(
                        angle: .value("Amount", item.total),
                        innerRadius: .ratio(0.55),
                        angularInset: 2
                    )
                    .cornerRadius(4)
                }
                .frame(height: 240)
                
                // Center Label
                VStack(spacing: 2) {
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("$\(viewModel.totalSpent, specifier: "%.0f")")
                        .font(.title)
                }
            }
        }
        .padding(20)
    }
    
    private var barChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(.subheadline)
                
            // Bar Chart
            Chart(viewModel.categorySpending) { item in
                BarMark(
                    x: .value("Category", item.category.rawValue),
                    y: .value("Amount", item.total)
                )
                .cornerRadius(6)
                .annotation(position: .top, alignment: .center) {
                    Text("$\(item.total, specifier: "%.0f")")
                        .font(.system(size: 8, weight: .medium))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let amount = value.as(Double.self) {
                            Text("$\(amount, specifier: "%.0f")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    AxisGridLine(stroke: StrokeStyle(dash: [3]))
                        .foregroundStyle(.secondary)
                    }
                }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let lable = value.as(String.self) {
                            Text(lable)
                                .font(.system(size: 8))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .frame(height: 220)
        }
        .padding(20)
        
    }
    
    private var breakdownList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Breakdown")
                .font(.title)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ForEach(Array(viewModel.categorySpending.enumerated()), id: \.element.id) { index, item in
                    HStack(spacing: 14) {
                        // Color Dot
                        Circle()
                            .fill(.secondary)
                            .frame(width: 10, height: 10)
                        
                        // Icon and Name
                        Text(item.category.icon)
                        Text(item.category.rawValue)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        // Percentage
                        Text("\(item.percentage, specifier: "%.1f")%")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.secondary)
                            .clipShape(Capsule())
                        
                        // Amount
                        Text("$\(item.total, specifier: "%.2f")")
                            .frame(width: 72, alignment: .trailing)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    if index < viewModel.categorySpending.count - 1 {
                        Divider().padding(.leading, 40)
                    }
                }
            }
            
        }
    }
}

