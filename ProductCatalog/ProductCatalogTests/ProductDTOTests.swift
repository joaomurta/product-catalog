//
//  ProductCatalogTests.swift
//  ProductCatalogTests
//
//  Created by João Murta on 29/10/2026.
//

import Testing
import Foundation
@testable import ProductCatalog

struct ProductDTOTests {

    private let json = """
       {
         "products": [{
           "id": 1, "title": "Sample", "description": "A sample product",
           "category": "beauty", "price": 9.99, "discountPercentage": 10.5,
           "rating": 4.2, "stock": 5,
           "images": ["https://example.com/img/1.webp"],
           "thumbnail": "https://example.com/img/thumb.webp"
         }],
         "total": 194, "skip": 0, "limit": 1
       }
       """

    @Test("Decodes the page and map to the domain.")
        func decodesAndMaps() throws {
            let page = try JSONDecoder().decode(ProductsPageDTO.self, from: Data(json.utf8))
            #expect(page.total == 194)

            let product = try #require(page.products.first).toDomain()
            #expect(product.id == 1)
            #expect(product.details == "A sample product")
            #expect(product.imageURL?.absoluteString == "https://example.com/img/1.webp")
        }

    @Test("without images, use thumbnail")
        func fallsBackToThumbnail() {
            let dto = ProductDTO(
                id: 1, title: "t", description: "d", category: "c", price: 1,
                discountPercentage: 0, rating: 1, stock: 1,
                images: nil, thumbnail: "https://example.com/thumb.webp"
            )
            #expect(dto.toDomain().imageURL?.absoluteString == "https://example.com/thumb.webp")
        }

    @Test("Reject images that are not HTTPS")
        func rejectsInsecureImage() {
            let dto = ProductDTO(
                id: 1, title: "t", description: "d", category: "c", price: 1,
                discountPercentage: 0, rating: 1, stock: 1,
                images: ["http://example.com/a.png"], thumbnail: nil
            )
            #expect(dto.toDomain().imageURL == nil)
        }

}
