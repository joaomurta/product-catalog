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

        @Test("all products loaded")
        func loadsProducts() async {
            let repository = StubRepository(result: .success([.fixture(id: 1), .fixture(id: 2)]))
            let viewModel = await ProductListViewModel(repository: repository)

            await viewModel.load()

            #expect(viewModel.state == .loaded)
            #expect(viewModel.products.map(\.id) == [1, 2])
        }

        @Test("failed with message")
        func reportsFailure() async {
            let viewModel = await ProductListViewModel(repository: StubRepository(result: .failure(Failing())))

            await viewModel.load()

            #expect(viewModel.state == .failed("failing"))
            #expect(viewModel.products.isEmpty)
        }
    }
}
