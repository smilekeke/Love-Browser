//
//  WebViewLoadHtmlView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/12/16.
//

import SwiftUI

struct WebViewLoadHtmlView: View {
    
    var urlString: String = ""
    
    var body: some View {
        
        SettingWebView(url:urlString)
            .background(Color.white)
           
    }
}

struct WebViewLoadHtmlView_Previews: PreviewProvider {
    static var previews: some View {
        WebViewLoadHtmlView()
    }
}
