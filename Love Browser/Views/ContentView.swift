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
    @State private var openQRCodeView = false
    @State var openWallpaper = false
    @State var canBack = false
    @State var canForward = false
    
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
                    
                        currentModel.webViewModel.webView.reload()
                    }, addToHomePage: {
                        
                        if let url = currentModel.webViewModel.url  {
                            saveHomePageCategory(itemModel: HomePageItemModel(title: currentModel.webViewModel.title ?? "", image: "", icon: url.host!, link: currentModel.webViewModel.url?.absoluteString ?? ""))
                        }
                        
                    }, openQRCodeView: {
                       
                        openQRCodeView.toggle()
                        
                    },textFieldManger: textFieldManger)
                    .fullScreenCover(isPresented: $openQRCodeView) {
                        
                    } content: {

                        QRCodeView(urlString: text)
                    }

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
                        currentModel.updateUrl(url: query)
                        
                    }
                        .background(Color.black.opacity(0.3))
                        .padding(.bottom, keyboardHeightHelper.keyboardHeight-74)
                        .opacity(showSearchedWords ? 1 : 0)
                    
                }
                
                if !hideBottomView {
                    
                    BottomBar(clickHomeButton: {
                        
                        if isSearch {
                            text = ""
                            showBack = false
                            isSearch = false
                            showMore = false
                            showSearchIcon = true
                            currentModel.webViewModel.webView.backForwardList.perform(Selector(("_removeAllItems")))
                            pausePlay()
                            currentModel?.isDesktop = true
                            
                        } else {
                        
                            textFieldManger.textField.becomeFirstResponder()
                        }
                        
                    }, clickBackButton: {
                        
                        currentModel?.webViewModel.goBack()
                        
                    }, clickForwardButton: {

                        currentModel?.webViewModel.goForward()
                        
                    }, changeWallpaper: { str in
                        
                        changeWallpaper(str: str)
                        
                    }, openTabsView: {
                        
                        currentModel.updatePreviewImage()
                        
                    }, saveBookMarkCategory: {
                       
                        if !currentModel.isDesktop {
                            
                            if let str = currentModel.webViewModel.title, let link = currentModel.webViewModel.url?.absoluteString {
                                saveBookMarkCategory(title: str, url: link)
                            }
                            
                        } 
                        
                    }, openNewTabs: {
                        text = ""
                        showBack = false
                        isSearch = false
                        showMore = false
                        showSearchIcon = true
                        tabManagerModel.addTab()
                        
                    }, clickHistoryCell: { url in
                        
                        currentModel.isDesktop = false
                        currentModel.updateUrl(url: url)
                        
                    } ,showHome: isSearch)
                }

            }
            .environmentObject(appSettings)
            .environmentObject(tabManagerModel)
            
            .background(

                Image(backgroundImage)
                                .resizable()
                                .ignoresSafeArea()
                                .aspectRatio(contentMode: .fill)

            )
            
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
        }
        .background(Color.white)
        .onAppear {
            
            tabManagerModel.addTab()
            
            if !UserDefaults.standard.bool(forKey: "WriteHomePageData") {
                saveHomePageData()
            }
            UserDefaults.standard.set(true, forKey: "WriteHomePageData")
            
            let image = UserDefaults.standard.string(forKey: "SelectedWallpaper")
            backgroundImage = image ?? "default"
           
        }

    }
    
    
    func addHomeWebView(model: HomeViewModel) -> some View {
    
        HomeWebView(model: model,decidePolicy: { url in
            text = url
            
        }, didFinish: {title, url in
            
            currentModel.updatePreviewImage()
            
            if title != "" && url != "" {
                saveSearchHistoryCategory(title: title, url: url)
            }
            
        }, clickHomePageItem: { url in
            if url == "Wallpaper" {
                openWallpaper.toggle()
            } else {
                showSearchIcon = false
                showBack = false
                showMore = true
                isSearch = true
                showSearchedWords = false
                text = url
                textFieldManger.textField.resignFirstResponder()
                currentModel.updateUrl(url: url)
            }
            
        }).opacity(tabManagerModel.curUid == model.uid ? 1 : 0).environmentObject(tabManagerModel)
            .fullScreenCover(isPresented: $openWallpaper) {
                
            } content: {
                
                WallpaperView { str in
                    changeWallpaper(str: str)
                }
            }
    }
    
    
    func changeWallpaper(str: String) {
     
        // 切换壁纸
        backgroundImage = str
        appSettings.darkModeSettings = str == "default" ? true : false
    }
    
    
    // 暂停播放网页内的音频、视频
    func pausePlay() {
        
          if #available(iOS 15.0, *) {
              currentModel.webViewModel.webView.pauseAllMediaPlayback()
          } else {
              // Fallback on earlier versions
//              currentModel.updateUrl(url: "about:blank")
          }
    }
    
    
    // 添加到首页
    private func saveHomePageCategory(itemModel: HomePageItemModel) {
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let homePageCategory = HomePageCategory(context: viewContext)
        homePageCategory.title = itemModel.title
        homePageCategory.image = itemModel.image
        homePageCategory.icon = itemModel.icon
        homePageCategory.link = itemModel.link

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }

    func saveHomePageData() {
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Wallpaper", image: "menu_wallpaper", icon: "", link: "Wallpaper"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "FaceBook", image: "facebook", icon: "", link: "https://www.facebook.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Instagram", image: "instagram", icon: "", link: "https://www.instagram.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Twitter", image: "twitter", icon: "", link: "https://twitter.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Zoom", image: "zoom", icon: "", link: "https://zoom.com/"))
    }


    // 添加到历史记录
    private func saveSearchHistoryCategory(title: String,url: String) {
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let searchHistoryCategory = SearchHistoryCategory(context: viewContext)
        searchHistoryCategory.title = title
        
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        
        searchHistoryCategory.date = formatter1.string(from: Date())
        searchHistoryCategory.url = url

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }
    
    // 添加到书签
    private func saveBookMarkCategory(title: String, url: String) {

        let bookMarkCategory = BookMarkCategory(context: viewContext)
        bookMarkCategory.title = title
        bookMarkCategory.url = url

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


