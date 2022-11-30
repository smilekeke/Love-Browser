//
//  HomeWebView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/25.
//

import SwiftUI
import WebKit

struct HomeWebView: View  {
    
    @EnvironmentObject var appSettings: AppSetting
    
    @State var model: HomeViewModel
    
    var decidePolicy: (String) -> Void
    var didFinish:(String, String) -> Void

    var clickHomePageItem: (String) -> Void
    
    var body: some View {
    
        ZStack {
            
            WebView(webView: model.webViewModel.webView) { url in
                
                decidePolicy(url)
                
            } didFinish: { title, url in
                
                didFinish(title, url)
                
            }
             .edgesIgnoringSafeArea(.bottom)
             .opacity(model.isDesktop ? 0 : 1)
            
//            if webViewModel.isLoading {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle())
//            }
            
            
            HomePageView { url in
    
                clickHomePageItem(url)
            }
            .background(Color.white.opacity(appSettings.darkModeSettings ? 1 : 0))
            .opacity(model.isDesktop ? 1 : 0)
    
        }
        
    }
    
}

