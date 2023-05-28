//
//  WebViewVM.swift
//  browser
//
//  Created by Edgar Borovik on 24/05/2023.
//

import SwiftUI
import Combine
import WebKit

class WebViewVM: NSObject, ObservableObject {
    @AppStorage(Constants.historyItemsKey) private var navigationURLs = ""
    @Binding private var loadedURL: String
    private static var lastLoadedURL = ""

    init(loadedURL: Binding<String>) {
        _loadedURL = loadedURL
    }

    func isLoadingAllowed(forURL string: String) -> Bool {
        defer { Self.lastLoadedURL = string }
        return string != Self.lastLoadedURL
    }

    func stringToURL(_ string: String) -> URL? {
        var fullUrlString = string
        if !string.starts(with: Constants.httpShort) {
            fullUrlString = Constants.httpFull + fullUrlString
        }
        return URL(string: fullUrlString)
    }
}

extension WebViewVM: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let url = webView.url?.absoluteString, !url.isEmpty else { return }
        navigationURLs = url + Constants.historyItemsSeparator + navigationURLs
        loadedURL = url
    }
}
