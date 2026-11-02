//
//  OrderFormView.swift
//  ProductCatalog
//
//  Created by João Murta on 02/11/2026.
//

import SwiftUI

struct OrderFormView: View {
    @State private var viewModel = OrderFormViewModel()
    @FocusState private var focus: FormField?

    var body: some View {

        NavigationStack {

            Form {

                Section("Data") {
                    row(.name) {
                        TextField(
                            "Nome",
                            text: $viewModel.name)
                        .textContentType(.name)
                        .focused($focus, equals: .name)
                        .submitLabel(.next)

                    }

                    row(.email) {
                        TextField("Email", text: $viewModel.email)
                            .textContentType(.name)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .focused($focus, equals: .email)
                            .submitLabel(.next)

                    }

                    row(.number) {
                        TextField(
                            "Number",
                            text: $viewModel.number)
                        .keyboardType(.numberPad)
                        .focused($focus, equals: .number)

                    }

                    row(.promocode) {
                        TextField(
                            "Promo Code",
                            text: $viewModel.promoCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .focused($focus, equals: .promocode)
                        .submitLabel(.done)

                    }

                    Section("Delivery") {
                        row(.date) {
                            if viewModel.deliveryDate == nil {

                                Button("Set delivery date") {
                                    focus = nil
                                    viewModel.startPickingDate()
                                }
                            } else {
                                DatePicker(
                                    "Delivery date",
                                    selection: dateBinding,
                                    in: ...Date.now,
                                    displayedComponents: .date
                                )
                            }

                        }

                        row(.rating) {
                            Picker("Rating", selection: $viewModel.rating) {

                                Text("Set").tag(DeliveryRating?.none)
                                ForEach(DeliveryRating.allCases) { option in
                                    Text(option.title).tag(DeliveryRating?.some(option))
                                }
                            }
                            .pickerStyle(.menu)
                        }

                    }

                    Section {
                        Button("Submit") {
                            focus = nil
                            viewModel.submit()
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                    }

                }
            }
        }
    }

    private var dateBinding: Binding<Date> {
        Binding(
            get: { viewModel.deliveryDate ?? .now},
            set: { viewModel.deliveryDate = $0 }
        )
    }
    private func row<Content: View>(_ field: FormField, @ViewBuilder content: () -> Content) -> some View {


        VStack(alignment: .leading, spacing: 4) {
            content()

        }

    }
}
