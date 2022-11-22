//
//  WebViewModel.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/21.
//

import Foundation
import Combine
import WebKit

class WebViewModel: ObservableObject {
    
    @Published var webView = WKWebView()
     var canGoBack = false
     var canGoForward = false
    
        func updateData(with query: String?) {
            
            if let url = changeStringToUrl(query: query) {
        
                webView.load( URLRequest(url: url))
                
            }
        }
        
//        func webViewFavIcon() -> String {
//
//            let iconUrl = "http://www.google.com/s2/favicons?domain=www." + (webView.url?.host ?? "google.com")
//            return iconUrl
//        }
        
}

func changeStringToUrl(query: String?) -> URL? {
    
    guard let text = query?.trimmingCharacters(in: .whitespaces), !text.isEmpty else {
        return nil
    }
    
    if text.isVaildURL() {
        
        return URL(string: text)!
        
    } else {
        
       let urlString = "https://www.google.com/search?q=" + text
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return nil}
        
        return url
        
    }
}

