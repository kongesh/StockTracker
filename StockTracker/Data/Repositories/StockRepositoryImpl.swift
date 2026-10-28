//
//  StockRepositoryImpl.swift
//  StockTracker
//
//  Created by Kongesh iOS on 28/10/26.
//

import Foundation

public final class StockRepositoryImpl: StockRepository {
    private let webSocketService = StockWebSocketService()
    
    public init() {}
    
    public func fetchInitialStocks() async -> [Stock] {
        return [
            Stock(symbol: "AAPL", name: "Apple Inc.", price: 185.50, previousPrice: 182.00, stockDescription: "Designs and manufactures consumer electronics and software."),
            Stock(symbol: "GOOG", name: "Alphabet Inc.", price: 142.10, previousPrice: 144.50, stockDescription: "Multinational technology company focusing on internet services."),
            Stock(symbol: "TSLA", name: "Tesla, Inc.", price: 215.30, previousPrice: 205.00, stockDescription: "Electric vehicle and clean energy company."),
            Stock(symbol: "AMZN", name: "Amazon.com, Inc.", price: 178.25, previousPrice: 175.00, stockDescription: "E-commerce, cloud computing, and digital streaming giant."),
            Stock(symbol: "MSFT", name: "Microsoft Corp.", price: 415.20, previousPrice: 410.00, stockDescription: "Developer of personal computer software and cloud solutions."),
            Stock(symbol: "NVDA", name: "NVIDIA Corp.", price: 875.40, previousPrice: 850.00, stockDescription: "Pioneers in GPU-accelerated computing and AI chips."),
            Stock(symbol: "META", name: "Meta Platforms", price: 485.10, previousPrice: 490.00, stockDescription: "Social media and technology conglomerate."),
            Stock(symbol: "NFLX", name: "Netflix, Inc.", price: 610.50, previousPrice: 602.00, stockDescription: "Subscription streaming service and production company."),
            Stock(symbol: "AMD", name: "Advanced Micro Devices", price: 180.30, previousPrice: 177.50, stockDescription: "Semiconductor company developing computer processors."),
            Stock(symbol: "INTC", name: "Intel Corp.", price: 43.20, previousPrice: 44.10, stockDescription: "World's largest semiconductor chip manufacturer by revenue."),
            Stock(symbol: "JPM", name: "JPMorgan Chase & Co.", price: 195.80, previousPrice: 194.50, stockDescription: "Multinational investment bank and financial services firm."),
            Stock(symbol: "V", name: "Visa Inc.", price: 278.40, previousPrice: 276.90, stockDescription: "Global digital payments technology company."),
            Stock(symbol: "JNJ", name: "Johnson & Johnson", price: 158.60, previousPrice: 159.00, stockDescription: "Multinational pharmaceutical and medical technologies corporation."),
            Stock(symbol: "WMT", name: "Walmart Inc.", price: 60.30, previousPrice: 59.80, stockDescription: "Multinational retail corporation operating discount department stores."),
            Stock(symbol: "DIS", name: "Walt Disney Co.", price: 112.40, previousPrice: 110.10, stockDescription: "Diversified multinational mass media and entertainment conglomerate."),
            Stock(symbol: "PYPL", name: "PayPal Holdings", price: 62.10, previousPrice: 61.50, stockDescription: "Online payment system supporting global money transfers."),
            Stock(symbol: "BAC", name: "Bank of America", price: 35.80, previousPrice: 35.20, stockDescription: "Multinational financial services institution."),
            Stock(symbol: "XOM", name: "Exxon Mobil Corp.", price: 115.70, previousPrice: 116.20, stockDescription: "Multinational oil and gas energy corporation."),
            Stock(symbol: "PFE", name: "Pfizer Inc.", price: 27.40, previousPrice: 27.10, stockDescription: "Leading global pharmaceutical and biotechnology corporation."),
            Stock(symbol: "KO", name: "Coca-Cola Co.", price: 60.10, previousPrice: 59.90, stockDescription: "Multinational beverage corporation and manufacturer."),
            Stock(symbol: "PEP", name: "PepsiCo, Inc.", price: 172.50, previousPrice: 171.80, stockDescription: "Food, snack, and beverage multinational corporation."),
            Stock(symbol: "CSCO", name: "Cisco Systems", price: 48.90, previousPrice: 48.50, stockDescription: "Worldwide leader in IT, networking, and cybersecurity solutions."),
            Stock(symbol: "IBM", name: "IBM Corp.", price: 190.20, previousPrice: 188.40, stockDescription: "Global technology and consulting corporation."),
            Stock(symbol: "ORCL", name: "Oracle Corp.", price: 125.60, previousPrice: 124.00, stockDescription: "Computer technology corporation specializing in database software."),
            Stock(symbol: "NKE", name: "NIKE, Inc.", price: 98.30, previousPrice: 99.10, stockDescription: "Design, development, and worldwide marketing of footwear and apparel.")
        ]
    }
    
    public func connectWebSocket() async -> AsyncStream<String> {
        return await webSocketService.connect()
    }
    
    public func sendWebSocketMessage(text: String) async {
        await webSocketService.send(text: text)
    }
    
    public func disconnectWebSocket() async {
        await webSocketService.disconnect()
    }
}
