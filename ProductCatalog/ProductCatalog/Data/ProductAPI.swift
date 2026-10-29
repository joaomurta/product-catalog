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

struct ProductAPI: ProductAPIProtocol {

    private let session: URLSession

    private let baseURL = URL(string: "https://dummyjson.com")!

    init(session: URLSession) {
        self.session = session
    }

    static func makeSession() -> URLSession {

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        return URLSession(configuration: configuration)

    }
    func fetchProducts(limit: Int, skip: Int) async throws -> ProductsPageDTO {

        var components = URLComponents(
            url: baseURL.appending(path: "products"),
            resolvingAgainstBaseURL: false
        )

        components?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "skip", value: String(skip))
        ]

        guard let url = components?.url else { throw APIError.invalidURL }

        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else { throw APIError.badStatus(http.statusCode)}

        return try JSONDecoder().decode(ProductsPageDTO.self, from: data)
    }

}
