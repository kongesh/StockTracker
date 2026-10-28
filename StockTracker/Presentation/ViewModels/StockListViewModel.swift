//
//  StockListViewModel.swift
//  StockTracker
//
//  Created by Kongesh iOS on 27/10/26.
//

import Foundation
import SwiftUI

public enum SortOption: Sendable {
    case price
    case priceChange
}

@Observable
@MainActor
public final class StockListViewModel {
    public var stocks: [Stock] = []
    public var isConnected: Bool = false
    public var sortOption: SortOption = .price {
        didSet { sortStocks() }
    }
    
    private let repository: StockRepository
    private var feedTask: Task<Void, Never>?
    private var simulationTask: Task<Void, Never>?
    
    public init(repository: StockRepository = StockRepositoryImpl()) {
        self.repository = repository
        loadStocks()
    }
    
    public func loadStocks() {
        Task {
            self.stocks = await repository.fetchInitialStocks()
            sortStocks()
        }
    }
    
    public func toggleFeed() {
        if isConnected {
            stopFeed()
        } else {
            startFeed()
        }
    }
    
    public func startFeed() {
        isConnected = true
        
        feedTask = Task {
            let stream = await repository.connectWebSocket()
            for await _ in stream {}
        }
        
        simulationTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: Constants.updateIntervalNanoseconds)
                await MainActor.run {
                    self.updateAllStocks()
                }
            }
        }
    }
    
    public func stopFeed() {
        isConnected = false
        feedTask?.cancel()
        simulationTask?.cancel()
        Task {
            await repository.disconnectWebSocket()
        }
    }
    
    private func updateAllStocks() {
        for i in stocks.indices {
            let currentStock = stocks[i]
            let fluctuation = Double.random(in: -1.5...1.5)
            let newPrice = max(1.0, round((currentStock.price + fluctuation) * 100) / 100)
            
            stocks[i].previousPrice = currentStock.price
            stocks[i].price = newPrice
        }
        
        sortStocks()
        
        if let randomStock = stocks.randomElement() {
            let message = "TICK:\(randomStock.symbol):\(randomStock.price)"
            Task {
                await repository.sendWebSocketMessage(text: message)
            }
        }
    }
    
    private func sortStocks() {
        switch sortOption {
        case .price:
            stocks.sort { $0.price > $1.price }
        case .priceChange:
            stocks.sort { $0.priceChange > $1.priceChange }
        }
    }
}
