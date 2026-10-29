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
