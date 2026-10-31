//
//  StoredProduct.swift
//  ProductCatalog
//
//  Created by João Murta on 31/10/2026.
//

import Foundation

struct StoredProduct: Codable {

    let id: Int
    let title: String
    let details: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let imageURL: URL?

    init(_ product: Product) {
        id = product.id
        title = product.title
        details = product.details
        category = product.category
        price = product.price
        discountPercentage = product.discountPercentage
        rating = product.rating
        stock = product.stock
        imageURL = product.imageURL
    }

    func toDomain() -> Product {
            Product(
                id: id, title: title, details: details, category: category,
                price: price, discountPercentage: discountPercentage,
                rating: rating, stock: stock, imageURL: imageURL
            )
        }
}
