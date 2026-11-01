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

    
}
