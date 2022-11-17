//
//  HomePageView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/7.
//

import SwiftUI

struct HomePageView: View {

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

        }
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {

        HomePageView { query in
            
        }
    }
}


