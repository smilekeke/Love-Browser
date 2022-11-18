//
//  HomePageView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/7.
//

import SwiftUI

struct HomePageView: View {
    
    @State private var canBack = false
    @State private var canForward = false
    @State private var showHome = false
    
    @Binding var backgroundImage: String

    @FetchRequest(fetchRequest: HomePageCategory.all) private var  homePgaeCategorys:FetchedResults<HomePageCategory>
    
    var reloadWebView: (String) -> Void
    
    let rows = [GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80))]
    
    
    var body: some View {
        
        VStack {
    
            
            HomeSearchView { text in

                reloadWebView(text)
            }
            .padding(.top, 10)
            
            ScrollView {

                LazyVGrid(columns: rows, spacing: 20) {

                    ForEach(homePgaeCategorys, id: \.title) { homePageCategory in

                        VStack {

                            NavigationLink {

                            } label: {

                                Button {

                                    reloadWebView(homePageCategory.link ?? "")

                                } label: {
                                    
                                         AsyncImage(url: URL(string: homePageCategory.icon ?? "https://www.google.com/favicon.ico")) { image in
                                             
                                             image
                                                 .aspectRatio(contentMode: .fill)
                                                 .frame(width: 30, height: 30)
                                             
                                         } placeholder: {
                                             
                                             Color.white
                                         }
                                         .frame(width: 30, height: 30)
                                    

                                }
                                .frame(width: 56, height: 56)
                                .background(Color.lb_item)
                                .cornerRadius(8)
                            }

                            Text(homePageCategory.title ?? "")
                                .foregroundColor(Color.lb_black)

                        }

                    }
                }
            }
            .padding(.top, 20)
            
            BottomBar(clickHomeButton: {
            
                showHome = false
                
            }, clickBackButton: {

                
            }, clickForwardButton: {
                
            }, changeWallpaper: { str in
                
                // 切换壁纸
                backgroundImage = str
                
            }, openTabsView: {
                // open tabs View
      
                
            }, saveBookMarkCategory: {
                
            }, canBack: $canBack, canForward: $canForward, showHome: $showHome)

        }
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    
    @State static var backgroundImage = "bg1"
    
    static var previews: some View {
        
        HomePageView(backgroundImage: $backgroundImage) { query  in
            
        }
    }
}


