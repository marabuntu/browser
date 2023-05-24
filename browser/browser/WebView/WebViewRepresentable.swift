//
//  WebViewRepresentable.swift
//  browser
//
//  Created by Edgar Borovik on 23/05/2023.
//

import SwiftUI
import Combine
import WebKit

struct WebViewRepresentable {
    static private var webView = WKWebView()
    static private var subscription: AnyCancellable?
    @Binding private var urlString: String?
    @ObservedObject private var viewModel: WebViewVM

    init(urlBinding: Binding<String?>, viewModel: WebViewVM) {
        self.viewModel = viewModel
        _urlString = urlBinding
        createSubscription()
    }

    private func createSubscription() {
        Self.subscription = urlString.publisher
            .filter { viewModel.isLoadingAllowed(forURL: $0) }
            .sink {
                guard let url = viewModel.stringToURL($0) else { return }
                Self.webView.load(URLRequest(url: url))
            }
        Self.webView.navigationDelegate = viewModel
    }
}

extension WebViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        Self.webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
