//
//  BottomBar.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/6.
//

import SwiftUI
import WebKit

struct BottomBar: View {
    
    var clickHomeButton:() -> Void
    var clickBackButton:() -> Void
    var clickForwardButton:() -> Void
    var changeWallpaper: (String) -> Void
    var openTabsView:() -> Void // open tabs 标签页
    var saveBookMarkCategory:() -> Void
    var openNewTabs:() -> Void
    var clickHistoryCell:(String) -> Void
    
    var showHome = false

    @State var hasBackground = false
    
    // bottom
    @State var openTabs = false // open tabs 标签页
    @State var showMenu = false // 功能menu
    
    // menu
    @State var openHistory = false
    @State var openBookMark = false
    @State var openWallpaper = false
    @State var openSetting = false
    
    @EnvironmentObject var appSettings: AppSetting
    @EnvironmentObject var tabManagerModel: TabManagerModel
        
    var body: some View {
        
        GeometryReader { proxy in
            
            HStack( spacing: 0) {
                
                Button {
                    
                    clickBackButton()
                    
                } label: {
                    
                    
                    Image(tabManagerModel.canBack ? (appSettings.darkModeSettings ? "back_black" : "back_white") : (appSettings.darkModeSettings ? "back_grey" : "back_white"))
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth:.infinity)
                    
                }

                
                Button {
                   
                    clickForwardButton()
                    
                } label: {
                    
                    Image(tabManagerModel.canForward ? (appSettings.darkModeSettings ? "forward_black" : "forward_white") : (appSettings.darkModeSettings ? "forward_grey" : "forward_white"))
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth:.infinity)
                    
                }
                
                Button {
                
                    clickHomeButton()
                    
                } label: {
                    
                    Image(showHome ? (appSettings.darkModeSettings ? "homepage" : "homepage_white") : (appSettings.darkModeSettings ? "home_search_black" : "home_search_white"))
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth:.infinity)
                    
                }
                
            
                Button {
                    
                    openTabsView()
                    openTabs.toggle()
                    
                } label: {
                    
                    HStack {
                        
                        Image(appSettings.darkModeSettings ? "tabs_black" : "tabs_white")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .frame(maxWidth:.infinity)
                        
                        Text(String(tabManagerModel.list.count))
                            .foregroundColor(appSettings.darkModeSettings ? Color.lb_black : Color.white)
                            .font(
                                    .system(size: 12)
                                    .weight(.heavy)
                            )
                            .padding(.leading, tabManagerModel.list.count > 9 ? -41 : -37)
                            .padding(.top, 10)
                          
                    }
                    
                }
                
                .fullScreenCover(isPresented: $openTabs) {

                } content: {
                    TabsView {
                        openNewTabs()
                    }.environmentObject(tabManagerModel)
        
                }

                
                Button {
                    
                    showMenu.toggle()
                
                } label: {
                    
                    Image(appSettings.darkModeSettings ? "menu_black" : "menu_white")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth:.infinity)
                    
                }
    
                .fullScreenCover(isPresented: $showMenu) {
                    
                } content: {
                    
                    MenuView { title in
        
                        showMenu = false
            
                        if title == "History" {
                            openHistory.toggle()
                        }
                        if title == "Add Bookmark"{
                            
                            saveBookMarkCategory()
                        }
                        if title == "Bookmark" {
                            openBookMark.toggle()
                        }
                        if title == "Wallpaper" {
                            openWallpaper.toggle()
                        }
                        
                        if title == "Setting" {
                            openSetting.toggle()
                        }
                        
                    }
                    
                }
        
                .fullScreenCover(isPresented: $openWallpaper) {
                    
                } content: {
                    
                    WallpaperView { str in
                        changeWallpaper(str)
                    }
                }
                
                .fullScreenCover(isPresented: $openHistory) {
                    
                } content: {
                    
                    HistoryView { url in
                        clickHistoryOrBookMarkCell(url: url)
                    }
                }
                .fullScreenCover(isPresented: $openBookMark) {
                    
                } content: {
                    
                    BookMarkView { url in
                        clickHistoryOrBookMarkCell(url: url)
                    }
                }
                .fullScreenCover(isPresented: $openSetting) {
                    
                } content: {
                    
                    SettingView()
                }
               
            }
            
        }
        .frame(height: 30)
        .padding(.bottom,10)
        .padding([.horizontal,.top])
        
    }
    
    func clickHistoryOrBookMarkCell(url: String) {
        clickHistoryCell(url)
    }

}

//struct BottomBar_Previews: PreviewProvider {
//    
//    @State static var showHome = true
//    
//    static var previews: some View {
//        
//        BottomBar(clickHomeButton: {
//
//        }, clickBackButton: {
//
//        }, clickForwardButton: {
//
//        }, changeWallpaper: { str  in
//
//        }, openTabsView: {
//
//        }, saveBookMarkCategory: {
//
//        }, openNewTabs: {
//            
//        } ,openNewTabs: false, canBack: false , canForward: false,showHome: TabManager())
//
//    }
//}



