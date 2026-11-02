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

    var isValid: Bool {
        
    }

}
