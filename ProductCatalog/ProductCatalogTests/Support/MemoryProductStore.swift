//
//  MemoryProductStore.swift
//  ProductCatalog
//
//  Created by João Murta on 31/10/2026.
//

@testable import ProductCatalog

actor MemoryProductStore: ProductStoring {

    private(set) var saved: [Product]?

    init(initial: [Product]? = nil) {

        self.saved = initial
    }

    func load() -> [Product]? {
        saved
    }

    func save(_ products: [Product]) {
        saved = products
    }
}

struct FailingSaveStore: ProductStoring {
    struct SaveError: Error {}
    func load() async -> [Product]? { nil }
    func save(_ products: [Product]) async throws { throw SaveError() }
}
