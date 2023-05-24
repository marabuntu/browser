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
            ForEach(viewModel.history, id: \.self) { text in
                Button {
                    selectedUrl = text
                } label: {
                    Text(text)
                }
            }
        }
    }
}
