//
//  DefaultProductRepository.swift
//  ProductCatalog
//
//  Created by João Murta on 29/10/2026.
//

import Foundation

struct DefaultProductRepository : ProductRepository {

    private let api: ProductAPIProtocol
    private let pageSize: Int

    init(api: ProductAPIProtocol, pageSize: Int = 50) {
        self.api = api
        self.pageSize = pageSize
    }

    func loadProducts() async throws -> [Product] {
        var products : [Product] = []
        var skip = 0
        var total = Int.max

        while skip < total {

            let page = try await api.fetchProducts(limit: pageSize, skip: skip)

            guard !page.products.isEmpty else { break }

            products += page.products.map{$0.toDomain()}
            skip += page.products.count
            total = page.total
        }
        return products
    }
}
