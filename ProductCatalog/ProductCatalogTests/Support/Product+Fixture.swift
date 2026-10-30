//
//  Product+Fixture.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//
@testable import ProductCatalog

extension Product {

    static func fixture(id: Int = 1, title: String = "Product", details: String = "", rating: Double = 4) -> Product {
        Product(
            id: id, title: title, details: details, category: "test",
            price: 1, discountPercentage: 0, rating: rating, stock: 1, imageURL: nil
        )
    }
}
