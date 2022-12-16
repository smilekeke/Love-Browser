//
//  SettingWebView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/12/16.
//

import SwiftUI
import WebKit

struct SettingWebView: UIViewRepresentable {
    
    var url: String = ""
    
    func makeUIView(context: Context) -> WKWebView {
      
        let configuration = WKWebViewConfiguration().persistent()
        configuration.websiteDataStore = .nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsLinkPreview = true
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: URL(string: url)!))
//        webView.scrollView.showsVerticalScrollIndicator = false
//        webView.scrollView.showsHorizontalScrollIndicator = false
        return webView
        
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
            
    }
    
    func makeCoordinator() -> SettingWebViewCoordinator {
        
        SettingWebViewCoordinator()
    }
    
}

class SettingWebViewCoordinator: NSObject,WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

//        decidePolicy(webView.url?.absoluteString ?? "")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

//        didFinish(webView.title ?? "" ,webView.url?.absoluteString ?? "")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if  navigationAction.targetFrame?.isMainFrame == nil {
            
            webView.load(navigationAction.request)
            
        }
        
        return nil
    }
    
}
