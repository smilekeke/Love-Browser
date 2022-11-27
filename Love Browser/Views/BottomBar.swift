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
    
    @State var canBack = false
    @State var canForward = false
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
                    
                       
                    Image(canBack ? (appSettings.darkModeSettings ? "back_white" : "back_black") : (appSettings.darkModeSettings ? "back_grey" : "back_white"))
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth:.infinity)
                    
                }

                
                Button {
                   
                    clickForwardButton()
                    
                } label: {
                    
                    Image(canForward ? (appSettings.darkModeSettings ? "forward_white" : "forward_black") : (appSettings.darkModeSettings ? "forward_grey" : "forward_white"))
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth:.infinity)
                    
                }
                
                Button {
                
                    clickHomeButton()
                    
                } label: {
                    
                    Image(showHome ? "homepage" : (appSettings.darkModeSettings ? "home_search_black" : "home_search_white"))
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
                    
                    Image(appSettings.darkModeSettings ? "tabs_black" : "tabs_white")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth:.infinity)
                    
                }
                
                .fullScreenCover(isPresented: $openTabs) {


                } content: {

                    TabsView(openNewTabs: openNewTabs).environmentObject(tabManagerModel)
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
            
                        if title == "history" {
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
                    
                    HistoryView()
                }
                .fullScreenCover(isPresented: $openBookMark) {
                    
                } content: {
                    
                    BookMarkView()
                }
               
            }
            
        }
        .frame(height: 30)
        .padding(.bottom,10)
        .padding([.horizontal,.top])
        
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



