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
    
    @State private var showMore = false
    @State private var showSearchIcon = true
    @State private var showBack = false
    @State private var showSearchedWords = false
    @State private var backgroundImage = "default"
    @State private var hideSearchView = false
    @State private var hideBottomView = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    @ObservedObject var textFieldManger = TextFieldManger()
    @StateObject var appSettings = AppSetting()

    var homeViewModelList : Array<HomeViewModel> {
        return tabManagerModel.list
    }
    
    var currentIndex: Int {
        return tabManagerModel.getCurIndex()
    }
    
    @StateObject var tabManagerModel = TabManagerModel()

    
    
    var currentModel: HomeViewModel! {
        return homeViewModelList[self.currentIndex]
    }
    
    @State private var isSearch = false
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if !hideSearchView {
                    
                    SearchView(text: $text, showMore: $showMore, showSearchIcon: $showSearchIcon, showBack: $showBack, textDidChange: {
                        
                        showSearchedWords = text == "" ? false : true
                        
                    }, clickCancleButton: {
                        
                        showSearchedWords = false
                        
                    }, changeToWebView: { text in
                        
                        isSearch = true
                        showMore = true
                        showSearchIcon = false
                        showSearchedWords = false
                        
                        currentModel.updateUrl(url: text)
                    }, refreshWebView: {
                    
                        
                    }, addToHomePage: {
//
//                        saveHomePageCategory(itemModel: HomePageItemModel(title: currentTab.mo.webView.title ?? "", icon: "", link: currentTab.webViewModel.webView.url?.absoluteString ?? ""))
//
                    }, textFieldManger: textFieldManger)

                    .padding(.top, 10)
                }
                
                ZStack {
                    
                    ForEach(homeViewModelList, id: \.uid) { model in
                        addHomeWebView(model: model)
                    }
                    
                    SearchWordsView {
                        text = ""
                        showBack = false
                        showSearchedWords = false
                        textFieldManger.textField.resignFirstResponder()
                        
                    } reloadWebView: { query in
                        
                        text = query
                        showBack = false
                        showMore = true
                        showSearchedWords = false
                        textFieldManger.textField.resignFirstResponder()
                        isSearch = true
                        
                    }
                        .background(Color.black.opacity(0.3))
                        .padding(.bottom, keyboardHeightHelper.keyboardHeight-74)
                        .opacity(showSearchedWords ? 1 : 0)
                    
                }
                
                if !hideBottomView {
                    
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
                        
                        //TODO
//                        currentTab?.webViewModel.goBack()
                        
                    }, clickForwardButton: {
                        //TODO
//                        currentTab?.webViewModel.goForward()
                    }, changeWallpaper: { str in
                        
                        // 切换壁纸
                        backgroundImage = str
                        appSettings.darkModeSettings = str == "default" ? true : false
                        
                    }, openTabsView: {
                        
                    }, saveBookMarkCategory: {
                        
                    }, openNewTabs: {
                        tabManagerModel.addTab()
                    },
                              canBack: currentModel?.webViewModel.canGoBack ?? false,
                              canForward: currentModel?.webViewModel.canGoForward ?? false ,
                              showHome: isSearch)
                }

            }
            .environmentObject(appSettings)
            .environmentObject(tabManagerModel)
            
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
            
            if !UserDefaults.standard.bool(forKey: "WriteHomePageData") {
                saveHomePageData()
            }
            UserDefaults.standard.set(true, forKey: "WriteHomePageData")
            
            let image = UserDefaults.standard.string(forKey: "SelectedWallpaper")
            backgroundImage = image ?? "default"
           
        }

    }
    
    
    func addHomeWebView(model: HomeViewModel) -> some View {
    
        HomeWebView(model: model, didScroll: { offset in
            
        },clickHomePageItem: { url in
            showSearchIcon = false
            showBack = false
            showMore = true
            isSearch = true
            showSearchedWords = false
        }).opacity(tabManagerModel.curUid == model.uid ? 1 : 0)
    }
    
    func setBarsVisibility(offset: CGFloat, hide: Bool = false) {
        if offset > 20{
            hideSearchView = true
            hideBottomView = true
        } else {
            hideSearchView = false
            hideBottomView = false
        }
    }
    
    
    // 添加到首页
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

//struct ContentView_Previews: PreviewProvider {
//    @State static var text = ""
//    @State static var backgroundImage = "default"
//    
//    static var previews: some View {
//
//        ContentView().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
//    }
//
//}


