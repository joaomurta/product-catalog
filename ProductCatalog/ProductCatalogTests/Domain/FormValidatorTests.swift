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
}
