//
//  TextNormalizer.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

import Foundation

enum TextNormalizer {

    //text without accents and case sensitivity
    static func normalize(_ text: String) -> String {
        text.folding(options: [.diacriticInsensitive, .widthInsensitive], locale: nil).lowercased()
    }

    //ignoring whitespaces
    static func tokens(of query: String) -> [String] {
        normalize(query).split(whereSeparator: \.isWhitespace).map(String.init)
    }
}
