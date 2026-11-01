//
//  DeliveryRating.swift
//  ProductCatalog
//
//  Created by João Murta on 01/11/2026.
//

enum DeliveryRating: CaseIterable, Identifiable, Sendable {
    case poor, fair, good, veryGood, excellent

    var id: Self { self }
}
