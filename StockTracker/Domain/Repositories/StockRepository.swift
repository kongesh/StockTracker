//
//  StockRepository.swift
//  StockTracker
//
//  Created by Kongesh iOS on 28/10/26.
//

import Foundation

public protocol StockRepository: Sendable {
    func fetchInitialStocks() async -> [Stock]
    func connectWebSocket() async -> AsyncStream<String>
    func sendWebSocketMessage(text: String) async
    func disconnectWebSocket() async
}
