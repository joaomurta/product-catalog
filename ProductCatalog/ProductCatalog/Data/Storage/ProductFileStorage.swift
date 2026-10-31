//
//  ProductFileStorage.swift
//  ProductCatalog
//
//  Created by João Murta on 31/10/2026.
//
import Foundation
import OSLog

actor ProductFileStore: ProductStoring {

    private struct Payload: Codable {
        let version: Int
        let products: [StoredProduct]
    }

    private static let currentVersion = 1

    private let fileURL: URL
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ProductCatalog",
                                category: "storage")

    static func defaultFileURL() -> URL {
        URL.applicationSupportDirectory.appending(path: "ProductCatalog/products.json")
    }

    init(fileURL: URL = ProductFileStore.defaultFileURL()) {

        self.fileURL = fileURL
    }

    func load() async -> [Product]? {

        guard let data = try? Data(contentsOf: fileURL) else { return nil }

        guard let payload = try? JSONDecoder().decode(Payload.self, from: data),
              payload.version == Self.currentVersion,
              !payload.products.isEmpty else {

            logger.error("Stored catalog is invalid, discard")
            try? FileManager.default.removeItem(at: fileURL)
            return nil
        }

        return payload.products.map {$0.toDomain() }
    }

    func save(_ products: [Product]) async throws {

        let payload = Payload(version: Self.currentVersion, products: products.map(StoredProduct.init))
        let data = try JSONEncoder().encode(payload)

        try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)

        try data.write(to: fileURL, options: .atomic)

        var url = fileURL
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try? url.setResourceValues(values)
    }

}
