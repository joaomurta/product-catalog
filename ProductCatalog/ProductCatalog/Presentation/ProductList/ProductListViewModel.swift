//
//  ProductListViewModel.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable

final class ProductListViewModel {
    enum State: Equatable {
        case loading
        case loaded
        case failed(String)
    }

    private(set) var state: State = .loading
    private(set) var products: [Product] = []

    var query = ""

    private var searcher = ProductSearcher(products: [])

    private let repository: any ProductRepository

    init(repository: any ProductRepository) {

        self.repository = repository
    }

    var visibleProducts: [Product] {
        searcher.search(query)
    }

    func load() async {
        guard state != .loaded else { return }
        state = .loading

        do {
            
            let loadedProducts = try await repository.loadProducts()
            products = loadedProducts
            searcher = ProductSearcher(products: loadedProducts)
            state = .loaded

        } catch {
            if Task.isCancelled { return }
            state = .failed(error.localizedDescription)

        }
    }
}
