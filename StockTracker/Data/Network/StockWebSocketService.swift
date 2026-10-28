//
//  StockWebSocketService.swift
//  StockTracker
//
//  Created by Kongesh iOS on 27/10/26.
//

import Foundation

public actor StockWebSocketService {
    private var webSocketTask: URLSessionWebSocketTask?
    private let url: URL = {
        guard let url = URL(string: Constants.webSocketURL) else {
            preconditionFailure("Invalid WebSocket URL configured in Constants.")
        }
        return url
    }()
    
    public init() {}
    
    public func connect() -> AsyncStream<String> {
        AsyncStream { continuation in
            let session = URLSession(configuration: .default)
            let task = session.webSocketTask(with: url)
            self.webSocketTask = task
            task.resume()
            
            continuation.onTermination = { [weak self] _ in
                Task {
                    await self?.disconnect()
                }
            }
            
            func receiveMessage() {
                task.receive { result in
                    switch result {
                    case .success(let message):
                        switch message {
                        case .string(let text):
                            continuation.yield(text)
                        case .data(let data):
                            if let text = String(data: data, encoding: .utf8) {
                                continuation.yield(text)
                            }
                        @unknown default:
                            break
                        }
                        receiveMessage()
                    case .failure:
                        continuation.finish()
                    }
                }
            }
            receiveMessage()
        }
    }
    
    public func send(text: String) async {
        try? await webSocketTask?.send(.string(text))
    }
    
    public func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
}
