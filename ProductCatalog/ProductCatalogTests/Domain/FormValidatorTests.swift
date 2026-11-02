//
//  FormValidatorTests.swift
//  ProductCatalog
//
//  Created by João Murta on 01/11/2026.
//

import Testing
import Foundation
@testable import ProductCatalog

struct FormValidatorTests {

    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    private func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 10) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
    }

    private var validator: FormValidator {
        let today = date(2026, 10, 28, hour: 12)
        return FormValidator(calendar: calendar, now: { today })
    }

    // MARK: Name
    @Test("empty name or whitespaces")
    func blankName() {
        #expect(validator.validateName("") == .empty)
        #expect(validator.validateName("   ") == .empty)
        #expect(validator.validateName("João Murta") == nil)
    }

    // MARK: Email

    @Test("valid email", arguments: [
        "joao@example.com", "a.b+c@sub.example.pt", "JOAO@EXAMPLE.COM"
    ])
    func validEmails(_ email: String) {
        #expect(validator.validateEmail(email) == nil)
    }

    @Test("ivalid email", arguments: [
        "joao@", "joao@example", "@example.com",
        "joao example@x.com", "joao@x..com", "joão@example.com"
    ])
    func invalidEmails(_ email: String) {
        #expect(validator.validateEmail(email) == .invalidEmail)
    }

    @Test("blank email")
    func blankEmail() {
        #expect(validator.validateEmail("") == .empty)
        #expect(validator.validateEmail("  ") == .empty)
    }

    // MARK: Number

    @Test("valid numbeers", arguments: ["0", "123456"])
    func validNumbers(_ value: String) {
        #expect(validator.validateNumber(value) == nil)
    }

    @Test("invalid numbers", arguments: ["12a", "12 3", "-5", "1.5", "+1"])
    func invalidNumbers(_ value: String) {
        #expect(validator.validateNumber(value) == .notOnlyDigits)
    }

    @Test("blank number")
    func blankNumber() {
        #expect(validator.validateNumber("") == .empty)
    }

    // MARK: Promocode

    @Test("valid codes", arguments: ["ABC", "AB-CD-E", "A-B", "ABCDEFG"])
    func validPromoCodes(_ value: String) {
        #expect(validator.validatePromoCode(value) == nil)
    }

    @Test("invalid codes", arguments: [
        "AB", "ABCDEFGH", "abc", "Abc", "ÁBC", "AB1", "AB_C", "AB C"
    ])
    func invalidPromoCodes(_ value: String) {
        #expect(validator.validatePromoCode(value) == .invalidPromoCode)
    }

    @Test("blank code")
    func blankPromoCode() {
        #expect(validator.validatePromoCode("") == .empty)
    }

    // MARK: Date

    @Test("missing date")
    func missingDate() {
        #expect(validator.validateDate(nil) == .empty)
    }

    @Test("today and yesterday valid")
    func todayAndYesterdayAreValid() {
        #expect(validator.validateDate(date(2026, 10, 28)) == nil)
        #expect(validator.validateDate(date(2026, 10, 27)) == nil)
    }

    @Test("monday not allowed")
    func mondayIsRejected() {
        #expect(validator.validateDate(date(2026, 10, 26)) == .mondayNotAllowed)
    }

    @Test("future date not allowed")
    func futureIsRejected() {
        #expect(validator.validateDate(date(2026, 10, 29)) == .futureDate)
    }

    // MARK: Rating

    @Test("rating required")
    func ratingIsRequired() {
        #expect(validator.validateRating(nil) == .empty)
        #expect(validator.validateRating(.good) == nil)
    }
}
