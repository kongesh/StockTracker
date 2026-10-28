//
//  Stock.swift
//  StockTracker
//
//  Created by Kongesh iOS on 27/10/26.
//

import Foundation

public struct Stock: Identifiable, Codable, Sendable, Equatable {
    public var id: String { symbol }
    public let symbol: String
    public let name: String
    public var price: Double
    public var previousPrice: Double
    public let stockDescription: String
    
    public var priceChange: Double {
        price - previousPrice
    }
    
    public var priceChangePercentage: Double {
        guard previousPrice != 0 else { return 0 }
        return (priceChange / previousPrice) * 100
    }
    
    public init(symbol: String, name: String, price: Double, previousPrice: Double, stockDescription: String) {
        self.symbol = symbol
        self.name = name
        self.price = price
        self.previousPrice = previousPrice
        self.stockDescription = stockDescription
    }
}
