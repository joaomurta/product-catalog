//
//  OrderFormView.swift
//  ProductCatalog
//
//  Created by João Murta on 02/11/2026.
//

import SwiftUI

struct OrderFormView: View {
    @State private var vieewModel = OrderFormViewModel()

    var body: some View {

        NavigationStack {

            Form {

                Section("Data") {
                    row(.name) {

                    }
                }
            }
        }
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
