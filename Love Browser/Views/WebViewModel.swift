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
    
    func updateData(with query: String?) {
        
        if let url = changeStringToUrl(query: query) {
    
            webView.load( URLRequest(url: url))
            
        }
    }
        
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



