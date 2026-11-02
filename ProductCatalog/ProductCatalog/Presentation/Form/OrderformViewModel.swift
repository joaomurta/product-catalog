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
    var deliveryDate: Date?
    var rating: DeliveryRating?
    var showSuccess = false

    private var reveleadFields: Set<FormField> = []
    private let validator: FormValidator

    init(validator: FormValidator = FormValidator()) {

        self.validator = validator
    }

    func touch(_ field: FormField) {

        reveleadFields.insert(field)
    }

    func startPickingDate() {

        deliveryDate = .now
        touch(.date)
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
        reveleadFields = Set(FormField.allCases)
        showSuccess = isValid
    }

    func reset() {
        name = ""
        email = ""
        number = ""
        promoCode = ""
        deliveryDate = nil
        rating = nil
        reveleadFields = []
        showSuccess = false
    }

    func error(for field: FormField) -> FormFieldError? {
        reveleadFields.contains(field) ? validate(field) : nil
    }
}
