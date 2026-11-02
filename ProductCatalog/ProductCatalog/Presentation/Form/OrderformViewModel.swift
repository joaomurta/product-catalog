//
//  OrderformViewModel.swift
//  ProductCatalog
//
//  Created by João Murta on 02/11/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class OrderFormViewModel {

    var name = ""
    var email = ""
    var number = ""
    var promoCode = ""
    var deliveryDate = Date.now
    var rating: DeliveryRating = .veryGood
    var showSuccess = false

    private let validator: FormValidator
    private var showErrorFields = false

    init(validator: FormValidator = FormValidator()) {

        self.validator = validator
    }

    private func trimmed(_ text: String) -> String {

        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func validate(_ field: FormField) -> FormFieldError? {

        switch field {
        case .name: validator.validateName(trimmed(name))
        case .email: validator.validateEmail(trimmed(email))
        case .number: validator.validateNumber(trimmed(number))
        case .promocode: validator.validatePromoCode(trimmed(promoCode))
        case .date: validator.validateDate(deliveryDate)
        case .rating: validator.validateRating(rating)
        }
    }

    var isValid: Bool {
        FormField.allCases.allSatisfy { validate($0) == nil }
    }

    func submit() {
        showErrorFields = true
        showSuccess = isValid
    }

    func reset() {
        name = ""
        email = ""
        number = ""
        promoCode = ""
        deliveryDate = .now
        rating = .veryGood
        showErrorFields = false
        showSuccess = false
    }

    func error(for field: FormField) -> FormFieldError? {
        showErrorFields ? validate(field) : nil
    }
}
