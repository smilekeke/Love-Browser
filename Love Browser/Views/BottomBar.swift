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
    
    var canBack = false
    var canForward = false
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
    
    var body: some View {
        
        GeometryReader { proxy in
            
            HStack( spacing: 0) {
                
                Button {
                    
                    clickBackButton()
                    
                } label: {
                    
                       
                    Image(canBack ? "back_black" : (hasBackground ? "back_grey" : "back_white"))
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth:.infinity)
                    
                }.onAppear {
//                    hasBackground = true
                }

                
                Button {
                   
                    clickForwardButton()
                    
                } label: {
                    
                    Image(canForward ? "forward_black" : "forward_white")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth:.infinity)
                    
                }
                
                Button {
                
                    clickHomeButton()
                    
                } label: {
                    
                    Image(showHome ? "homepage" : "home_search_black")
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
                    
                    Image("tabs_black")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth:.infinity)
                    
                }
                
                .fullScreenCover(isPresented: $openTabs) {


                } content: {

                    TabsView()
                }

                
                Button {
                    
                    showMenu.toggle()
                
                } label: {
                    
                    Image("menu_black")
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

struct BottomBar_Previews: PreviewProvider {
    
    @State static var showHome = true
    
    static var previews: some View {
        
        BottomBar(clickHomeButton: {

        }, clickBackButton: {

        }, clickForwardButton: {

        }, changeWallpaper: { str  in

        }, openTabsView: {

        }, saveBookMarkCategory: {

        }, canBack: false, canForward: false , showHome: false)

    }
}



