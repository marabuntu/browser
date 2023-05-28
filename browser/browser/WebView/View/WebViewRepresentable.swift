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
    static private var observation: NSKeyValueObservation?
    @Binding private var urlString: String?
    @Binding private var downloadingProgress: Double
    @ObservedObject private var viewModel: WebViewVM

    init(urlBinding: Binding<String?>, downloadingProgress: Binding<Double>, viewModel: WebViewVM) {
        self.viewModel = viewModel
        _downloadingProgress = downloadingProgress
        _urlString = urlBinding
        createSubscription()
        setDelegatesAndObservations()
    }

    private func createSubscription() {
        Self.subscription = urlString.publisher
            .filter { viewModel.isLoadingAllowed(forURL: $0) }
            .sink { Self.webView.load(URLRequest(url: viewModel.stringToURL($0))) }
    }

    private func setDelegatesAndObservations() {
        Self.webView.navigationDelegate = viewModel
        Self.observation = Self.webView.observe(\WKWebView.estimatedProgress, options: .new) { _, change in
            Task { @MainActor in
                if change.newValue == 1 {
                    downloadingProgress = .zero
                    return
                }
                downloadingProgress = change.newValue ?? .zero
            }
        }
    }
}

extension WebViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        Self.webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
