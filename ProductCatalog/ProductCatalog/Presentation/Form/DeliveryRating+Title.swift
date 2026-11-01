//
//  DeliveryRating+Title.swift
//  ProductCatalog
//
//  Created by João Murta on 01/11/2026.
//

extension DeliveryRating {
    var title: String {
        switch self {
        case .poor: "Bad"
        case .fair: "Fair"
        case .good: "Good"
        case .veryGood: "Very Good"
        case .excellent: "Excellent"

        }
    }
}

