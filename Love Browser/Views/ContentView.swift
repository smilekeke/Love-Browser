//
//  ContentView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/6.
//

import SwiftUI
import CoreData
import WebKit

struct ContentView: View {
    
    @State private var text = ""
    @State private var isSearch = false
    @State private var showSearchedWords = false
    @State private var backgroundImage = "default"
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    @ObservedObject var webViewModel = WebViewModel()
    @ObservedObject var textFieldManger = TextFieldManger()
    @ObservedObject var tabManager = TabManager()
    
    @State var tabWebView: WebView!

    var body: some View {
        
        NavigationView {
            
            VStack {
                SearchView(text: $text, textDidChange: {
                    
                    showSearchedWords = true
                    
                }, clickCancleButton: {
                    
                    showSearchedWords = false
                    
                }, changeToWebView: { text in
                    isSearch = true
                    showSearchedWords = false
                    webViewModel.updateData(with: text)
                    
                }, textFieldManger: textFieldManger)
            
                .padding(.top, 10)
                
                ProgressView("", value: 10,total: 20)
                    .padding(.leading,20)
                    .padding(.trailing,20)
                    .padding(.top,-20)
                
                ZStack {
                
                    if isSearch {
                        
                        tabWebView
                    
                    } else {
                        
                        HomePageView(backgroundImage: $backgroundImage) { url in
                            isSearch = true
                            text = url
                            webViewModel.updateData(with: url)
                        }
                    }
                    
                    SearchWordsView {
                        
                        showSearchedWords = false
                        
                    } reloadWebView: { query in
                        
                        showSearchedWords = false
                        isSearch = true
                        text = query
                        webViewModel.updateData(with: query)
                        
                    }
                        .background(Color.black.opacity(0.3))
                        .padding(.bottom, keyboardHeightHelper.keyboardHeight-74)
                        .opacity(showSearchedWords ? 1 : 0)
                    
                }
                
                
                BottomBar(clickHomeButton: {
                    
                    if isSearch {
                        
                        isSearch = false
                        text = ""
                        
                    } else {
                        
                        textFieldManger.textField.becomeFirstResponder()

                    }
    
                }, clickBackButton: {
                    
                    webViewModel.webView.goBack()
    
                }, clickForwardButton: {
    
                    webViewModel.webView.goForward()
                }, changeWallpaper: { str in
    
                    // 切换壁纸
                    backgroundImage = str
    
                }, openTabsView: {
                    // open tabs View
                    print(tabManager.webviewCache.count)
    
                }, saveBookMarkCategory: {
    
                }, canBack: webViewModel.webView.canGoBack, canForward: webViewModel.webView.canGoForward, showHome: isSearch, dataModel: tabManager.webviewCache)

            }
            
            .background(

                Image(backgroundImage)
                                .resizable()
                                .ignoresSafeArea()
                                .aspectRatio(contentMode: .fill)
                                .opacity(isSearch ? 0 : 1)

            )
            
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
        }
        .onAppear {
            
            tabWebView = WebView(webView: webViewModel.webView, didStart: { text in
                
            }, didFinish: { title, url in
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                saveSearchHistoryCategory(date: dateFormatter.string(from: Date()), title: title, url: url)
            })
            
            tabManager.addWebView(webview: tabWebView)
            
            if !UserDefaults.standard.bool(forKey: "WriteHomePageData") {
                saveHomePageData()
            }
            UserDefaults.standard.set(true, forKey: "WriteHomePageData")
            
            let image = UserDefaults.standard.string(forKey: "SelectedWallpaper")
            backgroundImage = image ?? "default"
           
        }

    }
    
    private func saveHomePageCategory(itemModel: HomePageItemModel) {

        let homePageCategory = HomePageCategory(context: viewContext)
        homePageCategory.title = itemModel.title
        homePageCategory.icon = itemModel.icon
        homePageCategory.link = itemModel.link

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }

    func  saveHomePageData() {
        saveHomePageCategory(itemModel: HomePageItemModel(title: "FaceBook", icon: "www.facebook.com".appendedString(), link: "https://www.facebook.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Instagram", icon: "www.instagram.com".appendedString(), link: "https://www.instagram.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Twitter", icon: "www.twitter.com".appendedString(), link: "https://twitter.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Zoom", icon: "www.zoom.us".appendedString(), link: "https://zoom.com/"))
    }


    // 添加到历史记录
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
    
    // 添加到书签
    private func saveBookMarkCategory(itemModel: HomePageItemModel) {

        let bookMarkCategory = BookMarkCategory(context: viewContext)
        bookMarkCategory.title = itemModel.title
        bookMarkCategory.url = "https://"

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }
    
}

struct ContentView_Previews: PreviewProvider {
    @State static var text = ""
    @State static var backgroundImage = "default"
    
    static var previews: some View {

        ContentView().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
    }

}


