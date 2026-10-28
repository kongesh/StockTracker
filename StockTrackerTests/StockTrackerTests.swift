//
//  StockTrackerTests.swift
//  StockTrackerTests
//
//  Created by Kongesh iOS on 27/10/26.
//

import Testing
@testable import StockTracker

actor MockStockRepository: StockRepository {
    var stubbedStocks: [Stock] = [
        Stock(symbol: "AAPL", name: "Apple", price: 150.0, previousPrice: 140.0, stockDescription: "Tech"),
        Stock(symbol: "GOOG", name: "Google", price: 200.0, previousPrice: 190.0, stockDescription: "Search")
    ]
    var didConnect = false
    var didDisconnect = false
    var sentMessages: [String] = []

    func fetchInitialStocks() async -> [Stock] { stubbedStocks }
    func connectWebSocket() async -> AsyncStream<String> {
        didConnect = true
        return AsyncStream { _ in }
    }
    func sendWebSocketMessage(text: String) async { sentMessages.append(text) }
    func disconnectWebSocket() async { didDisconnect = true }
}

@MainActor
struct StockTrackerTests {

    @Test func testInitialStockLoading() async {
        let mockRepo = MockStockRepository()
        let viewModel = StockListViewModel(repository: mockRepo)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.stocks.count == 2)
        #expect(viewModel.stocks[0].symbol == "GOOG") // Highest price first
    }

    @Test func testSortingMechanism() async {
        let mockRepo = MockStockRepository()
        let viewModel = StockListViewModel(repository: mockRepo)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        viewModel.sortOption = .price
        #expect(viewModel.stocks[0].price >= viewModel.stocks[1].price)
        
        viewModel.sortOption = .priceChange
        #expect(viewModel.stocks[0].priceChange >= viewModel.stocks[1].priceChange)
    }
    
    @Test func testFeedConnectionToggle() async {
        let mockRepo = MockStockRepository()
        let viewModel = StockListViewModel(repository: mockRepo)
        
        #expect(viewModel.isConnected == false)
        viewModel.startFeed()
        #expect(viewModel.isConnected == true)
        
        viewModel.stopFeed()
        #expect(viewModel.isConnected == false)
    }
}
