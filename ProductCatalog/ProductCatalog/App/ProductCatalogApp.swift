//
//  ProductCatalogApp.swift
//  ProductCatalog
//
//  Created by João Murta on 29/10/2026.
//

import SwiftUI

@main
struct ProductCatalogApp: App {

    private let appEnvironment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            ProductListView(viewModel: appEnvironment.makeProductListViewModel())
        }
    }
}

