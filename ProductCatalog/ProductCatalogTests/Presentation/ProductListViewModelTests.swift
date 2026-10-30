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
    }

    private struct Failing: LocalizedError {
        var errorDescription: String? { "failing" }
    }

    @Test("all products loaded")
    func loadsProducts() async {
        let repository = StubRepository(result: .success([.fixture(id: 1), .fixture(id: 2)]))
        let viewModel = ProductListViewModel(repository: repository)

        await viewModel.load()

        #expect(viewModel.state == .loaded)
        #expect(viewModel.products.map(\.id) == [1, 2])
    }

    @Test("failed with message")
    func reportsFailure() async {
        let viewModel = ProductListViewModel(repository: StubRepository(result: .failure(Failing())))

        await viewModel.load()

        #expect(viewModel.state == .failed("failing"))
        #expect(viewModel.products.isEmpty)
    }

    @Test("Show first page")
    func showsFirstPageOnly() async {
        let products = (1...25).map { Product.fixture(id: $0) }
        let viewModel = ProductListViewModel(
            repository: StubRepository(result: .success(products)), pageSize: 10
        )
        await viewModel.load()

        #expect(viewModel.displayedProducts.count == 10)
        #expect(viewModel.products.count == 25)
    }

    @Test("Show on last line product")
    func loadsMoreOnLastVisibleRow() async {
        let products = (1...25).map { Product.fixture(id: $0) }
        let viewModel = ProductListViewModel(
            repository: StubRepository(result: .success(products)), pageSize: 10
        )
        await viewModel.load()

        //ignore: on the middle
        viewModel.loadMoreIfNeeded(after: viewModel.displayedProducts[3])
        #expect(viewModel.displayedProducts.count == 10)

        //show: last item
        viewModel.loadMoreIfNeeded(after: viewModel.displayedProducts[9])
        #expect(viewModel.displayedProducts.count == 20)

        //only 5 left
        viewModel.loadMoreIfNeeded(after: viewModel.displayedProducts[19])
        #expect(viewModel.displayedProducts.count == 25)

        //no more products
        viewModel.loadMoreIfNeeded(after: viewModel.displayedProducts[24])
        #expect(viewModel.displayedProducts.count == 25)
    }

    @Test("Reset to first page")
    func queryResetsPaging() async {
        let products = (1...25).map { Product.fixture(id: $0, title: "Item \($0)") }
        let viewModel = ProductListViewModel(
            repository: StubRepository(result: .success(products)), pageSize: 10
        )
        await viewModel.load()
        viewModel.loadMoreIfNeeded(after: viewModel.displayedProducts[9])
        #expect(viewModel.displayedProducts.count == 20)

        viewModel.updateQuery("item")
        #expect(viewModel.displayedProducts.count == 10)
    }
}
