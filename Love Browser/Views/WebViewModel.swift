//
//  WebViewModel.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/27.
//

import Foundation
import Combine
import WebKit

class WebViewModel {
    
    let webView: WKWebView

    init() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: .zero, configuration: configuration)

        setupBindings()
    }

//    @Published var urlString: String = ""
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var isLoading: Bool = false
    
    @Published var title: String? = ""
    @Published var url: URL? = nil

    private func setupBindings() {
        webView.publisher(for: \.canGoBack)
            .assign(to: &$canGoBack)

        webView.publisher(for: \.canGoForward)
            .assign(to: &$canGoForward)

        webView.publisher(for: \.isLoading)
            .assign(to: &$isLoading)
        
        webView.publisher(for: \.title)
            .assign(to: &$title)

        webView.publisher(for: \.url)
            .assign(to: &$url)
    }

    func loadUrl(urlString: String) {
        guard let url = changeStringToUrl(query: urlString) else {
            return
        }

        webView.load(URLRequest(url: url))
    }

    func goForward() {
        webView.goForward()
    }

    func goBack() {
        webView.goBack()
    }
    
    func changeStringToUrl(query: String) -> URL? {
        
        if let url = URL.webUrl(from: query) {
            return url
        }
        
        let urlString = "https://www.google.com/search?q=" + query

        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return nil}
        
        return url
            
    }
}
