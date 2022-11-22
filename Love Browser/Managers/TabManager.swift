//
//  TabManager.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/17.
//

import Foundation
import WebKit

class TabManager : ObservableObject {

    public var webviewCache = [WebView]()


    func addWebView(webview: WebView) {
        
        webviewCache.append(webview)
    }
    
    
    func deleteWebView(webview: WebView) {
        
    }

}
