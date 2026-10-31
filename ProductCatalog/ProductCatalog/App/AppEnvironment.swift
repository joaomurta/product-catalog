//
//  AppEnvironment.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

struct AppEnvironment {
    private let repository: any ProductRepository = DefaultProductRepository(
        api: ProductAPI(),
        store: ProductFileStore())

    @MainActor
    func makeProductListViewModel() -> ProductListViewModel {
        ProductListViewModel(repository: repository)
    }
}
