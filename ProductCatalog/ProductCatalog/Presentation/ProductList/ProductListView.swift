//
//  ProductListView.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

import SwiftUI
struct ProductListView: View {
    @State private var viewModel: ProductListViewModel
    @State private var selection: Product.ID?

    init(viewModel: ProductListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationSplitView {
            content
                .navigationTitle("Products")
                .searchable(text: $viewModel.query, prompt: "Search products")

        } detail: {
            ContentUnavailableView("Select Product", systemImage: "shippingBox")
        }.task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {

        switch viewModel.state {
        case .loading:
            ProgressView("Downloading products...")
        case .loaded:

            let results = viewModel.visibleProducts
            if results.isEmpty {
                ContentUnavailableView.search(text: viewModel.query)
            } else {
                List(viewModel.products, selection: $selection) { product in
                    ProductRow(product: product)
                }
            }

        case .failed(let message):
            ContentUnavailableView {
                Label("Load failed", systemImage: "")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") {
                    Task { await viewModel.load()}
                }.buttonStyle(.bordered)
            }
        }
    }
}
