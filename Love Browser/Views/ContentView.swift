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
    @State private var showMore = false
    @State private var showSearchIcon = true
    @State private var showBack = false
    @State private var showSearchedWords = false
    @State private var backgroundImage = "default"
    @State var preView: UIImage = UIImage()
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    @ObservedObject var webViewModel = WebViewModel()
    @ObservedObject var textFieldManger = TextFieldManger()
    @ObservedObject var tabManager = TabManager()
    @StateObject var appSettings = AppSetting()
    
    @State var tabWebView: WebView!

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                SearchView(text: $text, showMore: $showMore, showSearchIcon: $showSearchIcon, showBack: $showBack, textDidChange: {
                    
                    showSearchedWords = text == "" ? false : true
                    
                }, clickCancleButton: {
                    
                    showSearchedWords = false
                    
                }, changeToWebView: { text in
                    isSearch = true
                    showSearchedWords = false
                    webViewModel.updateData(with: text)
                    
                }, textFieldManger: textFieldManger, webViewModel: webViewModel)
            
                .padding(.top, 10)
                
                ZStack {
                
                    if isSearch {
                        
                        tabWebView
                            .onAppear {
                                appSettings.darkModeSettings = true
                            }
                            .onDisappear {
                                appSettings.darkModeSettings = (UserDefaults.standard.string(forKey: "SelectedWallpaper") == "default" || UserDefaults.standard.string(forKey: "SelectedWallpaper") == nil) ? true : false
                            }
                        
                    
                    } else {
                        
                        HomePageView() { url in
                            isSearch = true
                            text = url
                            webViewModel.updateData(with: url)
                        }
                    }
                    
                    SearchWordsView {
                        
                        text = ""
                        showBack = false
                        showSearchedWords = false
                        textFieldManger.textField.resignFirstResponder()
                        
                    } reloadWebView: { query in
                        
                        showSearchedWords = false
                        textFieldManger.textField.resignFirstResponder()
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
                        
                        text = ""
                        isSearch = false
                        showMore = false
                        showSearchIcon = true
                        
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
                    appSettings.darkModeSettings = str == "default" ? true : false
    
                }, openTabsView: {
                    // open tabs View
                    print(tabManager.webviewCache.count)
    
                }, saveBookMarkCategory: {
    
                }, showHome: isSearch, dataModel: tabManager.webviewCache)

            }
            .environmentObject(appSettings)
            
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
        .background(Color.white)
        .onAppear {
            
            tabWebView = WebView(webView: webViewModel.webView, preView: $preView, didStart: { text in
                tabWebView.preView = preView
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
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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


