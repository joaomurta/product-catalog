//
//  FormValidator.swift
//  ProductCatalog
//
//  Created by João Murta on 01/11/2026.
//

import Foundation

struct FormValidator: Sendable {

    private let calendar: Calendar
    private let now: @Sendable () -> Date

    init(calendar: Calendar = .current, now: @Sendable @escaping () -> Date = { .now }) {
        self.calendar = calendar
        self.now = now
    }

    private func isBlank(_ value: String) -> Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func validateName(_ value: String) -> FormFieldError? {
        isBlank(value) ? .empty : nil
    }

    func validateEmail(_ value: String) -> FormFieldError? {

        if isBlank(value) { return .empty }
        guard value.allSatisfy(\.isASCII),
              value.wholeMatch(of: #/[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}/#) != nil
        else { return .invalidEmail}

        return nil
    }

    func validateNumber(_ value: String) -> FormFieldError? {

        if isBlank(value) { return .empty }
        return value.allSatisfy { $0.isASCII && $0.isNumber } ? nil : .notOnlyDigits
    }

    func validatePromoCode(_ value: String) -> FormFieldError? {

        if isBlank(value) { return .empty }
        let isValid = (3...7).contains(value.count) && value.allSatisfy { character in
            guard let ascii = character.asciiValue else { return false }
            return (65...90).contains(ascii) || ascii == 45
        }

        return isValid ? nil : .invalidPromoCode
    }
    
    func validateDate(_ date: Date?) -> FormFieldError? {

        guard let date else {
            return .empty
        }

        if calendar.component(.weekday, from: date) == 2 { return .mondayNotAllowed }
        if calendar.startOfDay(for: date) > calendar.startOfDay(for: now()) { return .futureDate }
        return nil
    }
}
