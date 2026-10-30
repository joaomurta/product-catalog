//
//  RatingTier.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

enum RatingTier: Sendable {
    case low
    case medium
    case high
    
    init(rating: Double) {
        switch rating {
        case ..<3: self = .low
        case 3...4: self = .medium
        default: self = .high
        }
    }
}
