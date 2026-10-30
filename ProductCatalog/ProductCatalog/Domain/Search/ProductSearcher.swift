//
//  ProductSearcher.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

import Foundation

struct ProductSearcher: Sendable {

    private struct Entry: Sendable {
        let product: Product
        let searchableText: String
    }

    private let entries: [Entry]

    init(products: [Product]) {
        self.entries = products.map { product in
            Entry(
                product: product,
                searchableText: TextNormalizer.normalize("\(product.title) \(product.details)")
            )
        }
    }

    func search(_ query: String) -> [Product] {

        let terms = TextNormalizer.tokens(of: query)
        guard !terms.isEmpty else { return entries.map(\.product)}

        return entries.filter { entry in
            terms.allSatisfy { entry.searchableText.contains($0)}}.map(\.product)
    }
}

