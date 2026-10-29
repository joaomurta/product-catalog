//
//  ProductCatalogApp.swift
//  ProductCatalog
//
//  Created by João Murta on 29/10/2026.
//

import SwiftUI

@main
struct ProductCatalogApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Product Catalog")
                .task {
                    do {
                        let page = try await ProductAPI().fetchProducts(limit: 50, skip: 0)
                        print("✅ recebi \(page.products.count) de \(page.total)")
                    } catch {
                        print("❌", error)
                    }
                }
        }
    }
}

struct DebugListView: View {

    @State private var titles: [String] = []
    @State private var errorMessage: String?

    var body: some View {
        List(titles, id: \.self) { Text($0)}.overlay {
            if let errorMessage { Text(errorMessage).foregroundStyle(.red) }
            else if titles.isEmpty { ProgressView() }
        } .task {
            do {
                let repository = DefaultProductRepository(api: ProductAPI())
                titles = try await repository.loadProducts().map(\.title)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
