//
//  StockDetailView.swift
//  StockTracker
//
//  Created by Kongesh iOS on 27/10/26.
//

import SwiftUI

struct StockDetailView: View {
    let stock: Stock
    @Bindable var viewModel: StockListViewModel
    
    var liveStock: Stock {
        viewModel.stocks.first(where: { $0.symbol == stock.symbol }) ?? stock
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Price Banner
                HStack(alignment: .lastTextBaseline) {
                    Text(liveStock.price, format: .currency(code: "USD"))
                        .font(.system(size: 38, weight: .bold))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: liveStock.priceChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text(liveStock.priceChange, format: .currency(code: "USD"))
                        Text("(\(liveStock.priceChangePercentage, specifier: "%.2f")%)")
                    }
                    .font(.headline)
                    .foregroundColor(liveStock.priceChange >= 0 ? .green : .red)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // Description Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("About \(liveStock.name)")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(liveStock.stockDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Connection Status & Controls Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Feed Control")
                        .font(.headline)
                    
                    HStack {
                        Circle()
                            .fill(viewModel.isConnected ? Color.green : Color.red)
                            .frame(width: 12, height: 12)
                        Text(viewModel.isConnected ? "WebSocket Connected" : "WebSocket Disconnected")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(viewModel.isConnected ? "Stop Feed" : "Start Feed") {
                            viewModel.toggleFeed()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(viewModel.isConnected ? .red : .blue)
                    }
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(liveStock.symbol)
        .navigationBarTitleDisplayMode(.inline)
    }
}
