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
            VStack(alignment: .center, spacing: 20) {
                productImage

                Text(product.title).font(.title.bold())

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {

                    InfoTile(
                        label: "Price",
                        value: product.price
                            .formatted(.currency(code: "EUR"))
                    )
                    InfoTile(
                        label: "Discount",
                        value: (product.discountPercentage / 100)
                            .formatted(.percent.precision(.fractionLength(0...2)))
                    )
                    InfoTile(
                        label: "Stock",
                        value: product.stock
                            .formatted()
                    )
                    InfoTile(
                        label: "Rating",
                        value: product.rating
                            .formatted(.number.precision(.fractionLength(2))),
                        iconRating: product.rating)
                }

            }
            .padding()
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(product.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var productImage: some View {
        Group {
            if let url = product.imageURL {
                RemoteImage(url: url) { phase in
                    switch phase {
                    case .loading:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
        .accessibilityHidden(true)
    }
    
    private var placeholder: some View {
        Image(systemName: "photo")
            .font(.largeTitle)
            .foregroundStyle(.secondary)
    }
}

#Preview("with image") {
    NavigationStack { ProductDetailView(product: .preview()) }
}

#Preview("without image") {
    NavigationStack { ProductDetailView(product: .preview(imageURL: nil)) }
}
