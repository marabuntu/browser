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
    @AppStorage(Constants.historyItemsKey) private var navigationHistory: URLHistory = .empty
    @Binding private var loadedURL: String
    private static var lastLoadedURL = ""

    init(loadedURL: Binding<String>) {
        _loadedURL = loadedURL
    }

    func isLoadingAllowed(forURL string: String) -> Bool {
        defer { Self.lastLoadedURL = string }
        return string != Self.lastLoadedURL
    }

    func stringToURL(_ string: String) -> URL {
        guard
            string.firstIndex(of: " ") == nil,
            string.firstIndex(of: ".") != nil
        else {
            return stringToSearchURL(string)
        }
        let fullUrlString = string.starts(with: Constants.httpShort) ? string : Constants.httpFull + string
        return URL(string: fullUrlString)!
    }

    private func stringToSearchURL(_ string: String) -> URL {
        URL(string: Constants.googleSearchPattern + string.replacingOccurrences(of: " ", with: "+"))!
    }
}

extension WebViewVM: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let url = webView.url?.absoluteString, !url.isEmpty else { return }
        navigationHistory.add(item: .init(title: url, date: .init()))
        loadedURL = url
    }
}
