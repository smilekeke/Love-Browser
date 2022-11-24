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
    
    let webView: WKWebView

    init() {
        
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    }
    
    func updateData(with query: String) {
        
        if let url = changeStringToUrl(query: query) {
    
            webView.load( URLRequest(url: url))
            
        }
    }
        
}

func changeStringToUrl(query: String) -> URL? {
    
    if let url = URL.webUrl(from: query) {
        return url
    }
    
    let urlString = "https://www.google.com/search?q=" + query

    guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return nil}
    
    return url
        
}



