//
//  OrderFormView.swift
//  ProductCatalog
//
//  Created by João Murta on 02/11/2026.
//

import SwiftUI

struct OrderFormView: View {
    @State private var viewModel = OrderFormViewModel()

    var body: some View {

        NavigationStack {

            Form {

                Section("Data") {
                    row(.name) {
                        TextField("Nome", text: $viewModel.name)
                            .textContentType(.name)
                            .submitLabel(.next)

                    }

                    row(.email) {
                        TextField("Email", text: $viewModel.email)
                            .textContentType(.name)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .submitLabel(.next)

                    }

                    row(.number) {
                        TextField(
                            "Number",
                            text: $viewModel.number)
                            .keyboardType(.numberPad)
                            .submitLabel(.next)

                    }

                    row(.promocode) {
                        TextField(
                            "Promo Code",
                            text: $viewModel.promoCode)
                            .textContentType(.name)
                            .submitLabel(.next)

                    }

                    Section("Delivery") {
                        row(.date) {
                            if viewModel.deliveryDate == nil {

                                Button("Set delivery date") {
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
                            TextField("Nome", text: $viewModel.name)
                                .textContentType(.name)
                                .submitLabel(.next)

                        }

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

#Preview {

    OrderFormView()
}
