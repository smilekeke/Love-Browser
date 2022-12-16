//
//  FindInPageView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/23.
//

import SwiftUI
import WebKit

struct FindInPageView: View {
    
    @State var text = ""
    
    @State var webView: WKWebView
    @State var searchTerm: String = ""
    var current: Int = 0
    var total: Int = 0

    
    var body: some View {
        
        let textField = TextField("", text: $text)
       
        HStack {
            
            // 待完成需求
            
            Button {
                
            } label: {
                
                Image("back_black")
            }
            
            Button {
                webView.evaluateJavaScript("window.__firefox__.findNext()")
            } label: {
                Image("forward_black")
            }
            
            textField
                .textFieldStyle(.roundedBorder)
                .onChange(of: text) { newValue in
                    search(forText: newValue)
                }
            
            Button {
                webView.evaluateJavaScript("window.__firefox__.findDone()")
                UIApplication.shared.keyWindow?.endEditing(true)
            } label: {
                Text("Done")
            }
            
        }
        .frame(height: 30)
        .background(Color.white)
        .padding(.bottom,10)
        .padding([.horizontal,.top])
    }
    
    
    func search(forText text: String) {
        if text != searchTerm  {
            searchTerm = text
        }
        
        
        let escaped =
        text.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\'", with: "\\\'")
        
        webView.evaluateJavaScript("window.__firefox__.find('\(escaped)')")
    }
}

struct FindInPageView_Previews: PreviewProvider {
    static var previews: some View {
        FindInPageView(webView: WKWebView())
    }
}
