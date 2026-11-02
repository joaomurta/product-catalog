//
//  ProductCatalogApp.swift
//  ProductCatalog
//
//  Created by João Murta on 29/10/2026.
//

import SwiftUI

@main
struct ProductCatalogApp: App {

    private let appDependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {

            RootView(dependencies: appDependencies)
        }
    }
}

