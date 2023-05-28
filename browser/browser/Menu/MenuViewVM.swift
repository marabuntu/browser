//
//  MenuViewVM.swift
//  browser
//
//  Created by Edgar Borovik on 24/05/2023.
//

import SwiftUI

protocol MenuViewVMProtocol: ObservableObject, AnyObject {
    var history: URLHistory { get }
    func separatedByBaseURL(urls: [String]) -> [[String]]
    func baseURL(of url: String) -> String?
    func textForMenuButton(from urlString: String) -> String
}

final class MenuViewVM: MenuViewVMProtocol {
    @AppStorage(Constants.historyItemsKey) private var navigationHistory: URLHistory = .empty
    @Published var history: URLHistory = .empty

    init() {
        history = navigationHistory
    }

    func separatedByBaseURL(urls: [String]) -> [[String]] {
        var results = [[String]]()
        urls.forEach {
            var isAdded = false
            for (idx, result) in results.enumerated() where !result.isEmpty {
                if baseURL(of: result.first!) == baseURL(of: $0) {
                    results[idx].append($0)
                    isAdded = true
                    break
                }
            }
            if !isAdded {
                results.append([$0])
            }
        }
        return results
    }

    func baseURL(of url: String) -> String? {
        var baseURL = url
        if url.starts(with: Constants.httpsFull) {
            baseURL = String(baseURL.dropFirst(Constants.httpsFull.count))
        }
        if url.starts(with: Constants.httpFull) {
            baseURL = String(baseURL.dropFirst(Constants.httpFull.count))
        }
        guard let indexOfFirstSlash = baseURL.firstIndex(of: "/") else { return nil }
        return String(baseURL.dropLast(baseURL.count - indexOfFirstSlash.utf16Offset(in: baseURL)))
    }

    func textForMenuButton(from urlString: String) -> String {
        var buttonLabel = urlString
        if buttonLabel.contains(Constants.httpsFull) {
            buttonLabel = buttonLabel.replacingOccurrences(of: Constants.httpsFull, with: "")
        }
        if buttonLabel.contains(Constants.httpFull) {
            buttonLabel = buttonLabel.replacingOccurrences(of: Constants.httpFull, with: "")
        }
        if buttonLabel.last == "/" {
            buttonLabel = String(buttonLabel.dropLast())
        }
        return buttonLabel
    }
}
