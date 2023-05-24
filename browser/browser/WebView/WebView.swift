//
//  WebView.swift
//  browser
//
//  Created by Edgar Borovik on 24/05/2023.
//

import SwiftUI

struct WebView: View {
    @Binding var urlString: String?

    var body: some View {
        WebViewRepresentable(urlBinding: $urlString, viewModel: WebViewVM())
    }
}
