//
//  WebView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/6.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let webView: WKWebView
    
    var decidePolicy: (String) -> Void
    var didFinish: (String, String) -> Void
    var didScroll: () -> Void
    var didEndScroll: () -> Void
    
    func makeUIView(context: Context) -> some WKWebView {
        
        print("webview makeUIView is called")
        
        webView.allowsLinkPreview = true
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator
        return webView

    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
    
    func makeCoordinator() -> WebViewCoordinator {

        WebViewCoordinator { url in

            decidePolicy(url)

        } didFinish: { title, url in

            didFinish(title, url)

        } didScroll: {
            
            didScroll()
            
        } didEndScroll: {
            
            didEndScroll()
            
        }
    }

}



class WebViewCoordinator: NSObject,WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {

    var decidePolicy: (String) -> Void
    var didFinish: (String, String) -> Void
    var didScroll: () -> Void
    var didEndScroll: () -> Void

    init(decidePolicy: @escaping (String) -> Void = {_ in}, didFinish: @escaping (String, String) -> Void = {_, _ in }, didScroll:@escaping () -> Void, didEndScroll: @escaping () -> Void) {
        self.decidePolicy = decidePolicy
        self.didFinish = didFinish
        self.didScroll = didScroll
        self.didEndScroll = didEndScroll
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        decidePolicy(webView.url?.absoluteString ?? "")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        didFinish(webView.title ?? "" ,webView.url?.absoluteString ?? "")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
        if navigationAction.targetFrame?.isMainFrame == true {

            if let url = navigationAction.request.url   {

                decidePolicy(url.absoluteString)

            }
 
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if  navigationAction.targetFrame?.isMainFrame == nil {
            
            webView.load(navigationAction.request)
            
        }
        
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.isDragging) {
            didScroll()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        didEndScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndScroll()
    }

}
