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
            form
                .navigationTitle("Form")
                .toolbar { keyboardToolbar }
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
                .focused($focus, equals: .name)
                .submitLabel(.next)

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
        }

    }

    @ViewBuilder
    private var dateControl: some View {
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

    @ToolbarContentBuilder
    private var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {

            Spacer()
            Button("Completed") { focus = nil}
        }
    }

    private var submitSection: some View {
        Section {
            Button("Submit") {
                focus = nil
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
        .onSubmit(advanceFocus)
        .onChange(of: focus) { oldValue, _ in
            if let oldValue { viewModel.touch(oldValue) }
        }
        .onChange(of: viewModel.deliveryDate) { viewModel.touch(.date) }
        .onChange(of: viewModel.rating) { viewModel.touch(.rating) }

    }

    private func advanceFocus() {
        switch focus {
        case .name: focus = .email
        case .email: focus = .number
        default: focus = nil
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
