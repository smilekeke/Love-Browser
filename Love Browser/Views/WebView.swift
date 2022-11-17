//
//  WebView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/6.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    var url: String
    let webView: WKWebView
    
    var didStart: (String) -> Void
    var didFinish: (String,String) -> Void
    
    func makeUIView(context: Context) -> some UIView {

        webView.navigationDelegate = context.coordinator
        return webView
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
    
    func makeCoordinator() -> WebViewCoordinator {
      
        WebViewCoordinator { url in
            
           didStart(url)
            
        } didFinish: { title, url in
          
            didFinish(title,url)
        }
    }
    
}

class WebViewModel: ObservableObject {

    let webView: WKWebView

    
    init() {
        
        webView = WKWebView()
    }
    
    func updateData(with query: String?) {
    
        if let url = changeStringToUrl(query: query) {
    
            webView.load( URLRequest(url: url))
        }
    }

    func webViewCanGoBack() -> Bool {
        return webView.canGoBack

    }
    
    func webViewCanGoForward() -> Bool {
        
        return webView.canGoForward
    }
    
}

func changeStringToUrl(query: String?) -> URL? {
    
    guard let text = query?.trimmingCharacters(in: .whitespaces), !text.isEmpty else {
        return nil
    }
    
    if text.isVaildURL(url: text) {
        
        return URL(string: text)!
        
    } else {
        
       let urlString = "https://www.google.com/search?q=" + text
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return nil}
        
        return url
        
    }
}

class WebViewCoordinator: NSObject,WKNavigationDelegate {
    
    var didStart: (String) -> Void
    var didFinish: (String,String) -> Void
    
    init(didStart: @escaping (String) -> Void = {_ in}, didFinish: @escaping (String,String) ->Void = {_,_ in }) {
        self.didStart = didStart
        self.didFinish = didFinish
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       
        didStart(webView.url?.absoluteString ?? "")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
     
        didFinish(webView.title ?? "", webView.url?.absoluteString ?? "")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
}

