//
//  DefaultProductRepository.swift
//  ProductCatalog
//
//  Created by João Murta on 29/10/2026.
//

import Foundation
import OSLog

struct DefaultProductRepository : ProductRepository {

    private let api: ProductAPIProtocol
    private let store: any ProductStoring
    private let pageSize: Int
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ProductCtalog",
                                category: "repository")

    init(api: ProductAPIProtocol, store: any ProductStoring, pageSize: Int = 50) {
        self.api = api
        self.store = store
        self.pageSize = pageSize
    }

    func loadProducts() async throws -> [Product] {

        if let stored = await store.load() {

            return stored
        }

        let products = try await downloadAll()

        //save , just if download is completed
        do {
            try await store.save(products)
        } catch {
            logger.error("catalog not saved \(error.localizedDescription)")
        }

        return products

    }

    private func downloadAll() async throws -> [Product] {

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
