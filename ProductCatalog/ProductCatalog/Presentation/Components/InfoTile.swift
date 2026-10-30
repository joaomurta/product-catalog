//
//  InfoTitle.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//
import SwiftUI

struct InfoTile: View {

    let label: String
    let value: String
    var iconRating: Double? = nil

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack {
                if let iconRating {
                    RatingIcon(rating: iconRating)
                }
                Text(value)
                    .font(.title3.weight(.semibold))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
    }
}
