//
//  InfoTitle.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//
import SwiftUI

struct InfoTitle: View {

    let label: String
    let value: String
    var iconRating: Double? = nil

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            Text(label)
            HStack {
                if let iconRating {
                    RatingIcon(rating: iconRating)
                }
                Text(value)
            }
        }
    }
}
