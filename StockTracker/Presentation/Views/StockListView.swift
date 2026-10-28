//
//  StockListView.swift
//  StockTracker
//
//  Created by Kongesh iOS on 27/10/26.
//

import SwiftUI

struct StockListView: View {
    @State private var viewModel = StockListViewModel()
    @State private var hasInitialized = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Connection Header & Controls
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(viewModel.isConnected ? Color.green : Color.red)
                            .frame(width: 10, height: 10)
                        Text(viewModel.isConnected ? "Connected" : "Disconnected")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleFeed()
                    }) {
                        Text(viewModel.isConnected ? "Stop Feed" : "Start Feed")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.isConnected ? Color.red.opacity(0.15) : Color.blue.opacity(0.15))
                            .foregroundColor(viewModel.isConnected ? .red : .blue)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                
                // Sorting Picker
                Picker("Sort By", selection: $viewModel.sortOption) {
                    Text("Price").tag(SortOption.price)
                    Text("Price Change").tag(SortOption.priceChange)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Stock List
                List(viewModel.stocks) { stock in
                    NavigationLink(destination: StockDetailView(stock: stock, viewModel: viewModel)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(stock.symbol)
                                    .font(.headline)
                                Text(stock.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(stock.price, format: .currency(code: "USD"))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: stock.priceChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                                    Text(stock.priceChange, format: .currency(code: "USD"))
                                }
                                .font(.caption2)
                                .foregroundColor(stock.priceChange >= 0 ? .green : .red)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Stock Ticker")
            .onAppear {
                // Only auto-start on initial app launch. Respects manual stop/start choices thereafter.
                if !hasInitialized {
                    hasInitialized = true
                    viewModel.startFeed()
                }
            }
        }
    }
}
