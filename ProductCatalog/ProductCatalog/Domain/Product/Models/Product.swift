//
//  Product.swift
//  ProductCatalog
//
//  Created by João Murta on 29/10/2026.
//

import Foundation

struct Product: Identifiable, Hashable, Sendable {
    let id: Int
    let title: String
    let details: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let imageURL: URL?
}
