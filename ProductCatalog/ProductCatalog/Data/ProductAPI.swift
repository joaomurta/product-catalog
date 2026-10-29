//
//  ProductAPI.swift
//  ProductCatalog
//
//  Created by João Murta on 29/10/2026.
//

import Foundation

protocol ProductAPIProtocol: Sendable {
    func fetchProducts(limit: Int, skip: Int) async throws -> ProductsPageDTO
}

enum APIError: LocalizedError {

    case invalidURL
    case invalidResponse
    case badStatus(Int)
    var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL"
        case .invalidResponse: "Invalid Response"
        case .badStatus(let code): "Server error code \(code)"
        }
    }
}

