//
//  WebView.swift
//  browser
//
//  Created by Edgar Borovik on 24/05/2023.
//

import SwiftUI

struct WebView: View {
    @Binding var urlString: String?
    @Binding var progress: Double

    var body: some View {
        WebViewRepresentable(urlBinding: $urlString, downloadingProgress: $progress, viewModel: WebViewVM())
    }
}
