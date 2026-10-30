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
    
}
