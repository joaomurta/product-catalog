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
    private(set) var query = ""

    private var searcher = ProductSearcher(products: [])
    private var displayedCount: Int
    private let pageSize: Int
    private let repository: any ProductRepository

    init(repository: any ProductRepository, pageSize: Int = 50) {

        self.repository = repository
        self.pageSize = max(pageSize, 1)
        self.displayedCount = max(pageSize, 1)
    }

    var visibleProducts: [Product] {
        searcher.search(query)
    }

    var displayedProducts: [Product] {
        Array(visibleProducts.prefix(displayedCount))
    }

    func updateQuery(_ text: String) {

        query = text
        displayedCount = pageSize
    }

    func loadMoreIfNeeded(after product: Product) {

        let visible =  visibleProducts
        guard displayedCount < visible.count, visible[displayedCount - 1].id == product.id
        else {
            return
        }
        displayedCount += pageSize
        
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
