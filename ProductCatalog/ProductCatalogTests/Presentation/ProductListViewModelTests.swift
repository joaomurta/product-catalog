//
//  ProductListViewModelTests.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

import Testing
import Foundation
@testable import ProductCatalog

@MainActor
struct ProductListViewModelTests {
    private struct StubRepository: ProductRepository {

        let result: Result<[Product], Error>
        func loadProducts() async throws -> [Product] {
            try result.get()
        }

        private struct Failing: LocalizedError {
            var errorDescription: String? { "failing" }
        }
    }
}
