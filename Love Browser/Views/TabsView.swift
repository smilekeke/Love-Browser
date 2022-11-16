//
//  TabsView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/12.
//

import SwiftUI

// 标签页面
struct TabsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let ItemModels = [HomePageItemModel(logo: "search", title: "wallpaper", linkUrl: "http://baidu.com"),
                      HomePageItemModel(logo: "search", title: "Instagram", linkUrl: "http://baidu.com"),
                      HomePageItemModel(logo: "search", title: "Twitter", linkUrl: "http://baidu.com"),
                      HomePageItemModel(logo: "search", title: "hh", linkUrl: "http://baidu.com"),
                      HomePageItemModel(logo: "search", title: "gg", linkUrl: "http://baidu.com"),
                      HomePageItemModel(logo: "search", title: "kk", linkUrl: "http://baidu.com")]
    
    let rows = [GridItem(.fixed((UIScreen.main.bounds.width - 45) / 2)), GridItem(.fixed((UIScreen.main.bounds.width - 45) / 2))]
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                LazyVGrid(columns: rows, spacing: 15) {
           
                    ForEach(ItemModels, id: \.title) { item in
                        
                        Button {
                            
                        } label: {
                            
                            Image(item.logo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                
                        }
                            .frame(width: (UIScreen.main.bounds.width - 45)/2, height: 214)
                            .background(Color.init("F5F5F7"))
                            .cornerRadius(12)

                    }
                }
                .padding(.top,24)
        
            }
                .navigationTitle("Open Tabs")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("vector")
                        }
                }
            }
            
        }

    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}

struct HomePageItemModel {
    let logo: String
    let title: String
    let linkUrl: String
    
}
