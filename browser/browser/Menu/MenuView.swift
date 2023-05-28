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
        Menu {
            ForEach(viewModel.history.itemsSeparatedByDates.reversed(), id: \.self) { historyItems in
                if !historyItems.isEmpty {
                    Text(Formatter.fullDayFormatter.string(from: historyItems.first!.date))
                    menuFor(urls: historyItems.map { $0.title })
                }
            }
        } label: {
            Image(systemName: "clock")
        }
    }

    private func menuFor(urls items: [String]) -> some View {
        ForEach(viewModel.separatedByBaseURL(urls: items), id: \.self) { urls in
            if urls.count > 1,
                let url = urls.first,
                let baseURLString = viewModel.baseURL(of: url)
            {
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

    private func createButton(for text: String) -> some View {
        Button {
            selectedUrl = text
        } label: {
            Text(viewModel.textForMenuButton(from: text))
        }
    }
}
