//
//  ProductRepository.swift
//  ProductCatalog
//
//  Created by João Murta on 29/10/2026.
//

protocol ProductRepository : Sendable {
    func loadProducts() async throws -> [Product]
}
