//
//  DefaultProductRepositoryTests.swift
//  ProductCatalog
//
//  Created by João Murta on 29/10/2026.
//

import Testing
@testable import ProductCatalog

private func makeDTO(id: Int) -> ProductDTO {

    ProductDTO(
        id: id, title: "Product \(id)", description: "d", category: "c",
        price: 1, discountPercentage: 0, rating: 4, stock: 1,
        images: nil, thumbnail: nil
    )
}

// Fake API
private struct FakeAPI: ProductAPIProtocol {

    let all: [ProductDTO]

    func fetchProducts(limit: Int, skip: Int) async throws -> ProductsPageDTO {

        let slice = Array(all.dropFirst(skip).prefix(limit))
        return ProductsPageDTO(products: slice, total: all.count, skip: skip, limit: limit)
    }

    //it says there are 100 products but returns empty pages.
    private struct LyingAPI: ProductAPIProtocol {
        func fetchProducts(limit: Int, skip: Int) async throws -> ProductsPageDTO {
            ProductsPageDTO(products: [], total: 100, skip: skip, limit: limit)
        }

        private struct FailingAPI:ProductAPIProtocol {
            struct Failure: Error {}

            func fetchProducts(limit: Int, skip: Int) async throws -> ProductsPageDTO {
                throw Failure()
            }
        }

        struct DefaultProductRepositoryTests {

            @Test("collect all pages")
            func collectsAllPages() async throws {
                let store = MemoryProductStore()
                let repository = DefaultProductRepository(api: FakeAPI(all: (1...7).map(makeDTO)), store: store, pageSize: 3)
                let products = try await repository.loadProducts()
                #expect(products.map(\.id) == Array(1...7))
            }

            @Test("empty catalog")
            func handlesEmptyCatalog() async throws {
                let store = MemoryProductStore()
                let repository = DefaultProductRepository(api: FakeAPI(all: []), store: store)
                #expect(try await repository.loadProducts().isEmpty)
            }

            @Test("reproduce an error")
            func reproduceErrors() async {
                let store = MemoryProductStore()
                let repository = DefaultProductRepository(api: FailingAPI(), store: store)
                await #expect(throws: FailingAPI.Failure.self) {
                    try await repository.loadProducts()
                }
            }

            @Test("download and save")
            func downloadsAndSaveOnFirstLaunch() async throws {
                let store = MemoryProductStore()
                let repository = DefaultProductRepository(api: FakeAPI(all: (1...7).map(makeDTO)), store: store)

                let products = try await repository.loadProducts()

                #expect(!products.isEmpty)
                #expect(await store.saved?.count == products.count)
            }

            @Test("use saved file and not api")
            func usesStoredProductsWithoutNetwork() async throws {
                let stored = [Product.fixture(id: 1), Product.fixture(id: 2)]
                let store = MemoryProductStore(initial: stored)

                let repository = DefaultProductRepository(api: FailingAPI(), store: store)

                let loaded = try await repository.loadProducts()

                #expect(loaded == stored)
            }

            @Test("failed download")
            func failedDownloadSavesNothing() async {
                let store = MemoryProductStore()
                let repository = DefaultProductRepository(api: FailingAPI(), store: store)

                await #expect(throws: (any Error).self) {
                    try await repository.loadProducts()
                }
                #expect(await store.saved == nil)
            }
        }
    }
}
