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

    }
}
