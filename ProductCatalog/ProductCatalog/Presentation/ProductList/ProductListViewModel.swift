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

    private let repository: any ProductRepository

    init(repository: any ProductRepository) {

        self.repository = repository
    }

    func load() async {
        guard state != .loaded else { return }
        state = .loading

        do {
            products =  try await repository.loadProducts()
            state = .loaded
        } catch {
            if Task.isCancelled { return }
            state = .failed(error.localizedDescription)

        }
    }
}
