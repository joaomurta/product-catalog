//
//  FormFieldError.swift
//  ProductCatalog
//
//  Created by João Murta on 01/11/2026.
//

enum FormFieldError: Equatable , Sendable {

    case empty
    case invalidEmail
    case notOnlyDigits
    case invalidPromoCode
    case mondayNotAllowed
    case futureDate
}
