//
//  ProductFileStoreTests.swift
//  ProductCatalog
//
//  Created by João Murta on 31/10/2026.
//

import Testing
import Foundation
@testable import ProductCatalog

struct ProductFileStoreTests {

    private func makeStore() -> (store: ProductFileStore, file: URL, cleanup: () -> Void) {
            let directory = FileManager.default.temporaryDirectory
                .appending(path: UUID().uuidString)
            let file = directory.appending(path: "products.json")
            return (ProductFileStore(fileURL: file), file,
                    { try? FileManager.default.removeItem(at: directory) })
        }

        private func writeRaw(_ text: String, to file: URL) throws {
            try FileManager.default.createDirectory(
                at: file.deletingLastPathComponent(), withIntermediateDirectories: true
            )
            try Data(text.utf8).write(to: file)
        }

        @Test("first launch")
        func missingFileReturnsNil() async {
            let (store, _, cleanup) = makeStore()
            defer { cleanup() }
            #expect(await store.load() == nil)
        }

        @Test("save and load, return products")
        func roundTrip() async throws {
            let (store, _, cleanup) = makeStore()
            defer { cleanup() }
            let products = (1...3).map { Product.fixture(id: $0, title: "Item \($0)") }

            try await store.save(products)

            #expect(await store.load() == products)
        }

        @Test("emprt catalog discard")
        func emptyCatalogIsDiscarded() async throws {
            let (store, file, cleanup) = makeStore()
            defer { cleanup() }
            try writeRaw(#"{"version":1,"products":[]}"#, to: file)

            #expect(await store.load() == nil)
        }
}
