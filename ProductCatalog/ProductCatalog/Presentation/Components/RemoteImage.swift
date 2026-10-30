//
//  RemoteImage.swift
//  ProductCatalog
//
//  Created by João Murta on 30/10/2026.
//

import SwiftUI
import UIKit

enum RemoteImagePhase {
    case loading
    case success(Image)
    case failure
}

struct RemoteImage<Content: View>: View {
    let url: URL
    private let content: (RemoteImagePhase) -> Content

    @State private var phase: RemoteImagePhase = .loading
    @State private var requestedURL: URL?

    init(url: URL, @ViewBuilder content: @escaping (RemoteImagePhase) -> Content) {
        self.url = url
        self.content = content
    }

    var body: some View {
        content(phase)
            .task(id: url) { await load() }
    }

    private func load() async {
        requestedURL = url
        phase = .loading
        do {
            let (data, response) = try await Task {
                try await URLSession.shared.data(from: url)
            }.value

            guard requestedURL == url else { return }
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  let image = UIImage(data: data) else {
                phase = .failure
                return
            }
            phase = .success(Image(uiImage: image))
        } catch {
            guard requestedURL == url else { return }
            phase = .failure
        }
    }
}
