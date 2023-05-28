//
//  WebView.swift
//  browser
//
//  Created by Edgar Borovik on 24/05/2023.
//

import SwiftUI

struct WebView: View {
    @Binding private var urlString: String?
    @Binding private var loadedURL: String
    @Binding private var progress: Double

    init(urlString: Binding<String?>, loadedURL: Binding<String>, progress: Binding<Double>) {
        _urlString = urlString
        _loadedURL = loadedURL
        _progress = progress
    }

    var body: some View {
        WebViewRepresentable(
            urlBinding: $urlString,
            downloadingProgress: $progress,
            viewModel: WebViewVM(loadedURL: $loadedURL)
        )
    }
}
