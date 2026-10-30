//
//  ProductRow.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//
 import SwiftUI
struct ProductRow: View {
    let product: Product
    
    var body: some View {
        
        HStack(spacing: 12) {
            Text(product.title).font(.headline)
            
            Spacer(minLength: 8)
            
            Text(product.rating, format: .number.precision(.fractionLength(2))).foregroundStyle(.secondary)
            RatingIcon(rating: product.rating)
                .font(.title2)
                .frame(width: 32)
        }
        .accessibilityElement(children: .combine)
    }
}
