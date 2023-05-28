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
    @State private var downloadingProgress: Double = .zero
    @State private var loadedURL = ""

    var body: some View {
        VStack {
            ProgressView(value: downloadingProgress, total: 1)
            HStack {
                TextField(Constants.searchFieldText, text: $userInputURL) {
                    webViewURL = userInputURL
                }
                .foregroundColor(.gray)

                MenuView(viewModel: MenuViewVM(), selectedUrlBinding: $selectedHistoryURL)
            }
            .padding(.init(top: 4, leading: 6, bottom: 4, trailing: 6))

            WebView(urlString: $webViewURL, loadedURL: $loadedURL, progress: $downloadingProgress)
        }.onChange(of: selectedHistoryURL) {
            guard let url = $0 else { return }
            userInputURL = url
            webViewURL = url
        }.onChange(of: loadedURL) {
            userInputURL = $0
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
