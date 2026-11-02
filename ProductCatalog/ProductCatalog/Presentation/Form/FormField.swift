//
//  FormField.swift
//  ProductCatalog
//
//  Created by João Murta on 01/11/2026.
//

enum FormField: Hashable, CaseIterable {

    case name, email, number, promoCode, date, rating

    var title: String {
        switch self {
        case .name: "Name"
        case .email: "Email"
        case .number: "Number"
        case .promoCode: "Promo Code"
        case .date: "Delivery Date"
        case .rating: "Rating"
        }
    }
}
