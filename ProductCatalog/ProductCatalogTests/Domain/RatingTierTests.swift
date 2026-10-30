//
//  RatingTierTests.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

import Testing
@testable import ProductCatalog

struct RatingTierTests {
    
    @Test("rating categories", arguments: [
        (0.0, RatingTier.low), (2.56, .low), (2.99, .low),
        (3.0, .medium), (3.5, .medium), (4.0, .medium),
        (4.01, .high), (5.0, .high)
    ])

    func tier(rating: Double, expected: RatingTier) {
        #expect(RatingTier(rating: rating) == expected)
    }
}
