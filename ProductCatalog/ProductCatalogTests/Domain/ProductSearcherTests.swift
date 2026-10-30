//
//  ProductSearcherTests.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

import Testing
@testable import ProductCatalog

struct ProductSearcherTests {
    private let searcher = ProductSearcher(products: [
        .fixture(id: 1, title: "Smartphone", details: "iPhone 17"),
        .fixture(id: 2, title: "Milk", details: "Dairy"),
        .fixture(id: 3, title: "Bubble gum", details: "Trident")
    ])

    @Test("get product", arguments: ["sma", "SMARTPHONE", "  smartphone   "])
    func findsSamsung(query: String) {
        #expect(searcher.search(query).map(\.id) == [1])
    }
}
