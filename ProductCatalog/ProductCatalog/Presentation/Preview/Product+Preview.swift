//
//  Product+Preview.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

#if DEBUG
import Foundation

extension Product {

    static func preview(
        imageURL: URL? = URL(string: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp")
    ) -> Product {
        Product(
            id: 1, title: "Essence Mask Lash Princess",
            details: "Popular MASK", category: "beauty",
            price: 9.99, discountPercentage: 10.48, rating: 2.56, stock: 99,
            imageURL: imageURL
        )
    }
}
#endif
