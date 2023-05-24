//
//  HomeView.swift
//  browser
//
//  Created by Edgar Borovik on 23/05/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var webViewURL: String?
    @State private var selectedHistoryURL: String?
    @State private var userInputURL = ""

    var body: some View {
        VStack {
            HStack {
                TextField(Constants.searchFieldText, text: $userInputURL) {
                    webViewURL = userInputURL
                }
                MenuView(viewModel: MenuViewVM(), selectedUrlBinding: $selectedHistoryURL)
            }
            .padding()

            WebView(urlString: $webViewURL)
        }.onChange(of: selectedHistoryURL) {
            guard let url = $0 else { return }
            userInputURL = url
            webViewURL = url
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
