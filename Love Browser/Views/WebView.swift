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
    
    var didStart: (String) -> Void
    var didFinish: (String,String) -> Void
    var didScroll:(CGFloat) -> Void
    
    func makeUIView(context: Context) -> some WKWebView {
        
        print("webview makeUIView is called")
        
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator
        return webView

    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
    
    func makeCoordinator() -> WebViewCoordinator {

        WebViewCoordinator { url in

            didStart(url)

        } didFinish: { title, url in

            didFinish(title,url)

        } didScroll: { offset in

            didScroll(offset)
        }
    }

}



class WebViewCoordinator: NSObject,WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {

    var didStart: (String) -> Void
    var didFinish: (String,String) -> Void
    var didScroll:(CGFloat) -> Void

    init(didStart: @escaping (String) -> Void = {_ in}, didFinish: @escaping (String,String) ->Void = {_,_ in }, didScroll: @escaping (CGFloat) -> Void = {_ in}) {
        self.didStart = didStart
        self.didFinish = didFinish
        self.didScroll = didScroll
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

    //UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        didScroll(scrollView.contentOffset.y)
    }

//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//
//    }
//
//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//
//    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {

        return true
    }



}
