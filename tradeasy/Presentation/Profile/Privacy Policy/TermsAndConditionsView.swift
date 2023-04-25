//
//  TermsAndConditionsView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 25/4/2023.
//

import SwiftUI

import WebKit

struct PrivacyPolicyView: View {
    var body: some View {
        WebView(urlString: "https://www.freeprivacypolicy.com/live/9558f205-3861-48e1-8889-ea59efa95b2b")
    }
}
struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
