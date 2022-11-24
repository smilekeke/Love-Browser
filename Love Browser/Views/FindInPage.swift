//
//  FindInPage.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/23.
//

import SwiftUI
import WebKit

protocol FindInPageDelegate: NSObjectProtocol {
    
    func updated(findInPage: FindInPage)

}

class FindInPage: NSObject {

    weak var delegate: FindInPageDelegate?
    let webView: WKWebView

    var searchTerm: String = ""
    var current: Int = 0
    var total: Int = 0

    init(webView: WKWebView) {
        self.webView = webView
        super.init()
    }

    func done() {
        webView.evaluateJavaScript("window.__firefox__.findDone()")
    }

    func next() {
        webView.evaluateJavaScript("window.__firefox__.findNext()")
    }

    func previous() {
        delegate?.updated(findInPage: self)
        webView.evaluateJavaScript("window.__firefox__.findPrevious()")
    }

    func search(forText text: String) -> Bool {
        guard text != searchTerm else { return false }
        searchTerm = text
        
        let escaped =
        text.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\'", with: "\\\'")
        
        webView.evaluateJavaScript("window.__firefox__.find('\(escaped)')")
        
        return true
    }

    func update(currentResult: Int?, totalResults: Int?) {
        current = currentResult ?? current
        total = totalResults ?? total
        delegate?.updated(findInPage: self)
    }

}

