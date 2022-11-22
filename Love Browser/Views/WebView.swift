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
    
    let webViewId: String = UUID().uuidString
    let webView: WKWebView
    @State var preView: UIImage?
    
    
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
            updatePreview()
        }
    }
    
    func preparePreview(completion: @escaping (UIImage?) -> Void) {

        DispatchQueue.main.async {

             UIGraphicsBeginImageContextWithOptions(webView.bounds.size, false, UIScreen.main.scale)

             webView.drawHierarchy(in: webView.bounds, afterScreenUpdates: true)

             let image = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()
             completion(image)
        }

    }

    private func updatePreview() {
        preparePreview { image in
            preView = image
        }
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
