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
    @Binding var tvViewModel: [ListModel]
    @State var model: HomeViewModel
    
    var decidePolicy: (String, String) -> Void
    var didFinish:(String, String) -> Void
    var didScroll:() -> Void
    var didEndScroll:() -> Void

    var clickHomePageItem: (String) -> Void
    var clickCancleButton:() -> Void
    var clickTVListItem: (ListModel) -> Void
    
    var body: some View {
    
        ZStack {
            
            WebView(webView: model.webViewModel.webView) { title, url in
                
                decidePolicy(title, url)
                
            } didFinish: { title, url in
                
                didFinish(title, url)
                
            } didScroll: {
                
                didScroll()
                
            } didEndScroll: {
                
                didEndScroll()
                
            }
             .edgesIgnoringSafeArea(.bottom)
             .opacity(model.isDesktop ? 0 : 1)
            
//            if webViewModel.isLoading {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle())
//            }
            
            
            HomePageView (tvViewModel: $tvViewModel) { url in

                clickHomePageItem(url)
                
            } clickCancleButton: {
                
                clickCancleButton()
                
            }  clickTVListItem: { listModel in
                
                clickTVListItem(listModel)
                
            }
            .background(Color.white.opacity(appSettings.darkModeSettings ? 1 : 0))
            .opacity(model.isDesktop ? 1 : 0)
    
        }
        
    }
    
}

