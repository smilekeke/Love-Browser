//
//  HomePageView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/7.
//

import SwiftUI

struct HomePageView: View {

    @EnvironmentObject var appSettings: AppSetting
    @FetchRequest(fetchRequest: HomePageCategory.all) private var  homePgaeCategorys:FetchedResults<HomePageCategory>
    
    var clickHomePageItem: (String) -> Void
    
    let rows = [GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80))]
    
    var body: some View {
        
        VStack {
            
            ScrollView {

                LazyVGrid(columns: rows, spacing: 20) {

                    ForEach(homePgaeCategorys, id: \.title) { homePageCategory in

                        VStack {

                            NavigationLink {

                            } label: {

                                Button {

                                    clickHomePageItem(homePageCategory.link ?? "")

                                } label: {
                                    
                                    if homePageCategory.image != nil && homePageCategory.image != "" {
                                        Image(homePageCategory.image!)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                        
                                    } else {
                                    
                                        
                                        AsyncImage(url: URL(string: homePageCategory.icon ?? "https://www.google.com/favicon.ico")) { image in
                                            
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30, height: 30)
                                            
                                        } placeholder: {
                                            
                                            Color.white
                                        }
                                        .frame(width: 30, height: 30)
                                    }

                                }
                                .frame(width: 56, height: 56)
                                .background(appSettings.darkModeSettings ? Color.lb_item : Color.white.opacity(0.2))
                                .cornerRadius(8)
                            }

                            Text(homePageCategory.title ?? "")
                                .foregroundColor(appSettings.darkModeSettings ? Color.lb_black : Color.white)
                                .font(.system(size: 12).weight(.medium))
                                .lineLimit(1)

                        }

                    }
                }
            }
            .padding(.top, 20)

        }
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        HomePageView() { query  in
            
        }
    }
}


