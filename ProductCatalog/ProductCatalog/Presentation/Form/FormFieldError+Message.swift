//
//  FormFieldError+Message.swift
//  ProductCatalog
//
//  Created by João Murta on 01/11/2026.
//

extension FormFieldError {

    var message: String {
        switch self {
        case .empty: "Required field"
        case .invalidEmail: "Invalid Email"
        case .notOnlyDigits: "Use only digits (0-9)"
        case .invalidPromoCode: "3 to 7 uppercase letters or hyphens, no accents"
        case .mondayNotAllowed: "Deliveries are not accepted on Mondays"
        case .futureDate: "The date cannot be in the future"
        }
    }
}
