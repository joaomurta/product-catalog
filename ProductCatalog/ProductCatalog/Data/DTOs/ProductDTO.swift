//
//  Data.swift
//  ProductCatalog
//
//  Created by João Murta on 29/10/2026.
//

import Foundation

struct ProductsPageDTO: Decodable, Sendable{

    let products: [ProductDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ProductDTO: Decodable, Sendable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let images: [String]?
    let thumbnail: String?
}

extension ProductDTO {

    //API model convert to Domain entity
    func toDomain() -> Product {
        Product(id: id, title: title, details: description, category: category, price: price, discountPercentage: discountPercentage, rating: rating, stock: stock, imageURL: Self.secureURL(images?.first ?? thumbnail))
    }

    // secure URL for safety
    private static func secureURL(_ string: String?) -> URL? {
            guard let string, let url = URL(string: string), url.scheme == "https" else { return nil }
            return url
        }
}
