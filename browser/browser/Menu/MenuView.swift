//
//  MenuView.swift
//  browser
//
//  Created by Edgar Borovik on 23/05/2023.
//

import SwiftUI

struct MenuView<MenuViewVM: MenuViewVMProtocol>: View {
    @ObservedObject var viewModel: MenuViewVM
    @Binding var selectedUrl: String?

    init(viewModel: MenuViewVM, selectedUrlBinding: Binding<String?>) {
        self.viewModel = viewModel
        _selectedUrl = selectedUrlBinding
    }

    var body: some View {
        Menu(Constants.historyButtonText) {
            ForEach(separateByBaseURLs(viewModel.history), id: \.self) { urls in
                if urls.count > 1, let url = urls.first, let baseURLString = baseURL(of: url) {
                    Menu(baseURLString) {
                        ForEach(urls, id: \.self) { url in
                            createButton(for: url)
                        }
                    }
                } else if let url = urls.first {
                    createButton(for: url)
                }
            }
        }
    }

    private func createButton(for text: String) -> some View {
        Button {
            selectedUrl = text
        } label: {
            Text(text)
        }
    }

    private func separateByBaseURLs(_ urls: [String]) -> [[String]] {
        var buf = [String]()
        var result = [[String]]()
        urls.forEach {
            if let last = buf.last, baseURL(of: last) == baseURL(of: $0) || buf.isEmpty {
                buf.append($0)
            } else {
                result.append(buf)
                buf = []
                buf.append($0)
            }
        }
        result.append(buf)
        result = result.filter { !$0.isEmpty }
        return result
    }

    private func baseURL(of url: String) -> String? {
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
}
