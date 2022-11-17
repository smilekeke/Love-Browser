//
//  HomeWebView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import SwiftUI

struct HomeWebView: View {
    
    @Binding var text: String
    
    @ObservedObject var webViewModel = WebViewModel()
     
    @Environment(\.managedObjectContext) private var viewContext

    private func saveSearchHistoryCategory(date: String, title: String,url: String) {

        let searchHistoryCategory = SearchHistoryCategory(context: viewContext)
        searchHistoryCategory.title = title
        searchHistoryCategory.date = date
        searchHistoryCategory.url = url

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }

    var body: some View {
        
        VStack {

            WebSearchView(text: $text) { query in
                
                // 点击键盘go开始搜索
                webViewModel.updateData(with: query)
                
            } cancleLoadQuery: {
                
            }
            
            WebView(url: text, webView: webViewModel.webView) { url in
                
                text = url
                
            } didFinish: { title, url in
                
                let formatter1 = DateFormatter()
                formatter1.dateStyle = .short
                saveSearchHistoryCategory(date:formatter1.string(from: Date.now), title: title, url: url)
                
            }
            
        }
      
    }
}


