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
    
    
//    init() {
//        self.applyLighthTheme()
//    }
//
//    private func applyLighthTheme() {
//        ThemeManager.shared.applyTheme(theme: LightTheme())
//    }

    
    var body: some View {
        
//        let theme = ThemeManager.shared.getTheme()
        
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

                                    Image(homePageCategory.icon ?? "")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)

                                }
                                .frame(width: 56, height: 56)
                                .background(Color.init("F5F5F7"))
                                .cornerRadius(8)
                            }

                            Text(homePageCategory.title ?? "")
                                .foregroundColor(Color.init("222222"))

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

        HomePageView(backgroundImage: $backgroundImage) { query in
            
        }
    }
}


