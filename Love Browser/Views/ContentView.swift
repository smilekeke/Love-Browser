//
//  ContentView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/6.
//

import SwiftUI
import CoreData
import WebKit
import AlertToast

struct ContentView: View {
    
    @State private var text = ""
    @State private var tvViewModel:  [ListModel] = []
    @State var segmentModels: [SegmentModel]
    @State private var showMore = false
    @State private var showSearchIcon = true
    @State private var showBack = false
    @State private var showToast = false
    @State private var showSearchedWords = false
    @State private var backgroundImage = "default"
    @State private var hideSearchView = false
    @State private var hideBottomView = false
    @State private var openQRCodeView = false
    @State var openWallpaper = false
    @State var openWatchList = false
    @State var openAdView = false
    @State var canBack = false
    @State var canForward = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    @ObservedObject var textFieldManger = TextFieldManger.shared
    @StateObject var appSettings = AppSetting()
    let adCoordinator = InterstitialAdCoordinator.shared
    

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
                        currentModel.updateUrl(url: text)
//                        currentModel.webViewModel.webView.reload()
                    }, addToHomePage: {
                        
                        if let url = currentModel.webViewModel.url  {
                            saveHomePageCategory(itemModel: HomePageItemModel(title: currentModel.webViewModel.title ?? "", image: "", icon: url.host!, link: currentModel.webViewModel.url?.absoluteString ?? ""))
                        }
                        
                    }, openQRCodeView: {
                       
                        openQRCodeView.toggle()
                        
                    }, showToastView: {
                        
                        showToast = true
                        
                    },textFieldManger: textFieldManger)
                    .fullScreenCover(isPresented: $openQRCodeView) {
                        
                    } content: {

                        QRCodeView(urlString: text)
                    }

                    .padding(.top, 10)
                }
                
                SegmentedView(segmentModels: $segmentModels, array: []) { model in
                    
                    tvViewModel = model.items ?? []
                    
                    if model.label == "Home" {
                         
                        clickHomeButton()
                        textFieldManger.textField.resignFirstResponder()
                    }
                }
                .frame(height: isSearch ? 0 : 47)
                    .opacity(isSearch ? 0 : 1)
                    .onAppear {
                        goToWatchButton()
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
                            clickHomeButton()
                        } else {
                            textFieldManger.textField.becomeFirstResponder()
                        }
                        
                    }, clickBackButton: {
                        
                        if currentModel.webViewModel.webView.backForwardList.backList.count == 0 || currentModel.webViewModel.webView.backForwardList.backList.first?.url.absoluteString == "about:blank" {
                
                            clickHomeButton()
                           
                        } else {
                            currentModel?.webViewModel.goBack()
                        }
                        
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
                        
                    }, clickCurrentTab: { isHome in
                        
                        isSearch = !isHome
                    }, clickHistoryCell: { url in
                        
                        currentModel.isDesktop = false
                        isSearch = true
                        showMore = true
                        showBack = false
                        currentModel.updateUrl(url: url)
                        
                    } ,showHome: isSearch)
                    .padding(.top, -12)
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
            .toast(isPresenting: $showToast) {
                AlertToast(displayMode: .alert, type: .regular, title: "copied!")
            }
            
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
    
    func clickHomeButton() {
            text = ""
            showBack = false
            isSearch = false
            showMore = false
            showSearchIcon = true
            currentModel.webViewModel.webView.load(URLRequest(url: URL(string: "about:blank")!))
            currentModel.webViewModel.webView.backForwardList.perform(Selector(("_removeAllItems")))
            pausePlay()
            currentModel?.isDesktop = true
    }
    
    
    func addHomeWebView(model: HomeViewModel) -> some View {
        
        HomeWebView(tvViewModel: $tvViewModel, model: model,decidePolicy: {title, url in
            text = url
            
            if  title != "" && url != "" && url != "about:blank" {
                saveSearchHistoryCategory(title: title, url: url)
            }
            
            if url.contains("https://viewasian.co/watch") {
                deleteSameWatchListData(url: url)
                saveWatchListCategory(url: url)
            }
            
        }, didFinish: {title, url in
            
            currentModel.updatePreviewImage()
            
            if url == "about:blank" {
                text = ""
            }
            
            if title != "" && url != "" && url != "about:blank" {
                saveSearchHistoryCategory(title: title, url: url)
            }
            
            if url.contains("https://viewasian.co//drama") {
                saveWatchListCategory(url: url)
            }
            
        }, didScroll: {
            
            hideBottomView = true
            
        }, didEndScroll: {
            
            hideBottomView = false
            
        }, clickHomePageItem: { url in
            if url == "Wallpaper" {
                openWallpaper.toggle()
            } else if url == "WatchList" {
                openWatchList.toggle()
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
            
        },clickCancleButton: {
            showSearchedWords = false
            text = ""
            showBack = false
            showSearchIcon = true
            textFieldManger.textField.resignFirstResponder()
            UIApplication.shared.windows.first?.endEditing(true)
            
        }, clickTVListItem: { model in
            isSearch = true
            showMore = true
            showSearchIcon = false
            showSearchedWords = false
            currentModel.updateUrl(url: model.url ?? "")
            
            openAdView.toggle()
    
        }).opacity(tabManagerModel.curUid == model.uid ? 1 : 0).environmentObject(tabManagerModel)
            .fullScreenCover(isPresented: $openWallpaper) {
                
            } content: {
                
                WallpaperView { str in
                    changeWallpaper(str: str)
                }
            }
            .fullScreenCover(isPresented: $openWatchList) {
               
            } content: {
                
                WatchListView { url in
                    isSearch = true
                    showMore = true
                    showSearchIcon = false
                    showSearchedWords = false
                    currentModel.updateUrl(url: url)
                } clickGoToWatchButton: {
                    goToWatchButton()
                }

            }
            .fullScreenCover(isPresented: $openAdView, content: {
                InterstitialAdView(openAdView: $openAdView)
            })
    }
    
    
    func changeWallpaper(str: String) {
     
        // 切换壁纸
        backgroundImage = str
        appSettings.darkModeSettings = str == "default" ? true : false
    }
    
    func goToWatchButton() {
        if segmentModels.count > 1 {
            segmentModels[0].isSelected = false
            segmentModels[1].isSelected = true
            tvViewModel = segmentModels[1].items ?? []
        }
    }
    
    
    // 暂停播放网页内的音频、视频
    func pausePlay() {
        
          if #available(iOS 15.0, *) {
              currentModel.webViewModel.webView.pauseAllMediaPlayback()
          } else {
              // on earlier versions
              currentModel.webViewModel.webView.load(URLRequest(url: URL(string: "about:blank")!))
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
        homePageCategory.date = Date()

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }

    func saveHomePageData() {
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Wallpaper", image: "menu_wallpaper", icon: "", link: "Wallpaper"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Watch List", image: "watch_list", icon: "", link: "WatchList"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "FaceBook", image: "facebook", icon: "", link: "https://www.facebook.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Instagram", image: "instagram", icon: "", link: "https://www.instagram.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Twitter", image: "twitter", icon: "", link: "https://twitter.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "YouTube", image: "youtube", icon: "", link: "https://www.youtube.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "TV", image: "tvIcon", icon: "", link: "https://viewasian.co/country/korean/"))
    }


    // 添加到历史记录
    private func saveSearchHistoryCategory(title: String,url: String) {
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let searchHistoryCategory = SearchHistoryCategory(context: viewContext)
        searchHistoryCategory.title = title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        searchHistoryCategory.shortDate = formatter.string(from: Date())
        
        searchHistoryCategory.date = Date()
        searchHistoryCategory.url = url

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }
    
    // 保存watchListHistory数据
    private func saveWatchListCategory(url: String) {
        
        let watchListCategory = WatchListCategory(context: viewContext)
        watchListCategory.url = url
        watchListCategory.cover = "https://imagecdn.me/cover/"+url.TransUrlStringToTitle()+".png"
        watchListCategory.title = url.TransUrlStringToTitle()
        watchListCategory.date = Date()
        
        do {

            try viewContext.save()
    
        } catch {

            print(error)
        }
    }
    
    //删除已存的watchListHistory数据
    private func deleteSameWatchListData(url: String) {
        let fetchWatchListResults = NSFetchRequest<WatchListCategory>(entityName: "WatchListCategory")
        fetchWatchListResults.predicate = NSPredicate(format: "title == %@", url.TransUrlStringToTitle())
        do {
            let watchListResults = try viewContext.fetch(fetchWatchListResults)
            for watchList in watchListResults {
                viewContext.delete(watchList)
            }
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            print("\(error)")
        }
    }
    
    // 添加到书签
    private func saveBookMarkCategory(title: String, url: String) {

        let bookMarkCategory = BookMarkCategory(context: viewContext)
        bookMarkCategory.title = title
        bookMarkCategory.url = url
        bookMarkCategory.date = Date()

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


