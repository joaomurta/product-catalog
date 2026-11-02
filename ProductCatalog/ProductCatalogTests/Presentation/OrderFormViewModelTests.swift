//
//  OrderFormViewModelTest.swift
//  ProductCatalog
//
//  Created by João Murta on 02/11/2026.
//

import Testing
import Foundation
@testable import ProductCatalog

@MainActor
struct OrderFormViewModelTests {

    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    private var tuesday: Date {
        calendar.date(from: DateComponents(year: 2026, month: 10, day: 27, hour: 10))!
    }
    private func makeViewModel() -> OrderFormViewModel {
        let today = calendar.date(from: DateComponents(year: 2026, month: 10, day: 28, hour: 12))!
        let viewModel = OrderFormViewModel(
            validator: FormValidator(calendar: calendar, now: { today })
        )
        viewModel.deliveryDate = tuesday
        return viewModel
    }

    private func fillWithValidData(_ viewModel: OrderFormViewModel) {
        viewModel.name = "João Murta"
        viewModel.email = "joao@example.com"
        viewModel.number = "123456"
        viewModel.promoCode = "ABC-D"
    }

    @Test("errors just on submit")
    func errorsStayHiddenBeforeSubmit() {
        let viewModel = makeViewModel()
        viewModel.email = "joao@"

        #expect(FormField.allCases.allSatisfy { viewModel.error(for: $0) == nil })
    }

    @Test("Empty errors")
    func submitEmptyShowsErrors() {
        let viewModel = makeViewModel()

        viewModel.submit()

        let textFields: [FormField] = [.name, .email, .number, .promoCode]
        #expect(textFields.allSatisfy { viewModel.error(for: $0) == .empty })
        #expect(viewModel.error(for: .date) == nil)
        #expect(viewModel.error(for: .rating) == nil)
        #expect(viewModel.showSuccess == false)
    }

    @Test("trimmed fields")
    func valuesAreTrimmed() {
        let viewModel = makeViewModel()
        fillWithValidData(viewModel)
        viewModel.email = "  joao@example.com  "

        viewModel.submit()

        #expect(viewModel.showSuccess)
    }

    @Test("Valid fields show success")
    func validDataShowsSuccess() {
        let viewModel = makeViewModel()
        fillWithValidData(viewModel)

        viewModel.submit()

        #expect(viewModel.showSuccess)
        #expect(FormField.allCases.allSatisfy { viewModel.error(for: $0) == nil })
    }


    @Test("clear data")
    func resetClearsEverything() {
        let viewModel = makeViewModel()
        fillWithValidData(viewModel)
        viewModel.rating = .excellent
        viewModel.submit()

        viewModel.reset()

        #expect(viewModel.name.isEmpty)
        #expect(viewModel.rating == .veryGood)
        #expect(viewModel.showSuccess == false)
        #expect(FormField.allCases.allSatisfy { viewModel.error(for: $0) == nil })
    }
}
