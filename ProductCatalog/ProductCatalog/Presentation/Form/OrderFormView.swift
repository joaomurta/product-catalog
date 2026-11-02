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
            form
                .navigationTitle("Form")
                .alert("Valid Form", isPresented: $viewModel.showSuccess) {
                    Button("OK") { viewModel.reset() }
                } message: {
                    Text("Valid fields success")
                }
        }
    }

    private var personalSection: some View {
        Section("Data") {
            row(.name) {
                TextField(
                    "Nome",
                    text: $viewModel.name)
                .textContentType(.name)
            }

            row(.email) {
                TextField(
                    "Email",
                    text: $viewModel.email)
                .textContentType(.name)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            }

            row(.number) {
                TextField(
                    "Number",
                    text: $viewModel.number)
                .keyboardType(.numberPad)
            }

            row(.promocode) {
                TextField(
                    "Promo Code",
                    text: $viewModel.promoCode)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
            }
        }

    }

    @ViewBuilder
    private var dateControl: some View {
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

    private var ratingPicker: some View {
        Picker("Rating", selection: $viewModel.rating) {

            Text("Set").tag(DeliveryRating?.none)
            ForEach(DeliveryRating.allCases) { option in
                Text(option.title).tag(DeliveryRating?.some(option))
            }
        }
        .pickerStyle(.menu)
    }

    private var deliverySection: some View {

        Section("Delivery") {
            row(.date) { dateControl }
            row(.rating) { ratingPicker }
        }
    }

    private var submitSection: some View {
        Section {
            Button("Submit") {
                viewModel.submit()
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
        }
    }

    private var form: some View {

        Form {
            personalSection
            deliverySection
            submitSection
        }
        .scrollDismissesKeyboard(.interactively)

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
            if let error = viewModel.error(for: field) {
                Text(error.message)
                    .font(.caption)
                    .foregroundStyle(.red)

            }
        }
    }
}
