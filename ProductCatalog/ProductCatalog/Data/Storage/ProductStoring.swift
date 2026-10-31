//
//  ProductStoring.swift
//  ProductCatalog
//
//  Created by João Murta on 31/10/2026.
//

protocol ProductStoring: Sendable {

    func load() async -> [Product]?
    func save(_ products: [Product]) async throws
}
