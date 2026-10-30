//
//  ProductDetailView.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

import SwiftUI

struct ProductDetailView: View {

    let product: Product

    var body: some View {
        ScrollView {
            VStack() {

            }
        }
    }

    @ViewBuilder
    private var productImage: some View {
        Group {
            if let url = product.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure:
                        //placeholder
                    default:
                        ProgressView()
                    }
                }
            } else {
                // placeholder
            }
        }

    }

    private var placeholder: some View {
        Image(systemName: ""))
    }
}
