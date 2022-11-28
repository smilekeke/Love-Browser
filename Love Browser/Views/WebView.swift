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
    var didFinish: (String) -> Void
    var didScroll:(CGFloat) -> Void
    
    func makeUIView(context: Context) -> some WKWebView {
        
        print("webview makeUIView is called")
        
        webView.allowsLinkPreview = true
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

        } didFinish: { url in

            didFinish(url)

        } didScroll: { offset in

            didScroll(offset)
        }
    }

}



class WebViewCoordinator: NSObject,WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {

    var decidePolicy: (String) -> Void
    var didFinish: (String) -> Void
    var didScroll:(CGFloat) -> Void

    init(decidePolicy: @escaping (String) -> Void = {_ in}, didFinish: @escaping (String) ->Void = {_ in }, didScroll: @escaping (CGFloat) -> Void = {_ in}) {
        self.decidePolicy = decidePolicy
        self.didFinish = didFinish
        self.didScroll = didScroll
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        decidePolicy(webView.url?.absoluteString ?? "")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        didFinish(webView.url?.absoluteString ?? "")
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

    //UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        didScroll(scrollView.contentOffset.y)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {

    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {

    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {

        return true
    }



}
