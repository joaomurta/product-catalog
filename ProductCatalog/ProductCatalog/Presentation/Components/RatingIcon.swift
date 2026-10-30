//
//  RatingIcon.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

import SwiftUI

struct RatingIcon: View {

    let rating: Double

    var body: some View {
        switch RatingTier(rating: rating) {
        case .low:
            Image(systemName: "hand.thumbsdown.fill").foregroundStyle(.red)
        case .medium:
            Image(systemName: "star.leadinghalf.filled").foregroundStyle(.orange)
        case .high:
            Image(systemName: "star.fill").foregroundStyle(.green)
        }
    }
}
