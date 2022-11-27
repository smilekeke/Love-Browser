//
//  TabsView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/12.
//

import SwiftUI
import Foundation
import WebKit

// 标签页面
struct TabsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isSearch = false
    
    @Binding var homeViewModelList:Array<HomeViewModel>
    
    var openNewTabs:() -> Void

    let gridWidth = (UIScreen.main.bounds.width - 45) / 2

    let rows = [GridItem(.fixed((UIScreen.main.bounds.width - 45) / 2)), GridItem(.fixed((UIScreen.main.bounds.width - 45) / 2))]
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                ScrollView {
                    
                    LazyVGrid(columns: rows, spacing: 15) {
                        
                        ForEach(homeViewModelList, id: \.uid) { homeViewModel in
                            
                            VStack {
                                
                                HStack {
                                
                                    Text(
                                        // TODO
//                                        tabModel.homeWebView.model.webView.title ??
                                        "首页")
                                        .font(.system(size: 12))
                                        .padding(.leading, 8)
                                        .padding(.top, 10)
                                    
                                    Spacer()
                                    
                                    Button {
                                        self.homeViewModelList.removeAll { item in
                                            item === homeViewModel
                                        }
                                    } label: {
                                        Image("deleteTab")
                                            .frame(width: 16, height: 16)
                                    }
                                    .buttonStyle(BorderedButtonStyle())
                                    .padding(.trailing, 8)
                                    
                                }
                                .frame(height: 20)
                                
                                Image(uiImage: (homeViewModel.previewImage))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: gridWidth, height: 214)
                                    .clipped()
                                
                            }
                            .frame(width: gridWidth, height: 234)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.lb_item, lineWidth: 2)
                            )
                            
                        }
                    }
                    .padding(.top,24)
                    
                }
                    .background(Color.lb_item)
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        openNewTabs()
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image("openTabs")
                    }
                    
                    Spacer()
                    
                    Button {
                        homeViewModelList.removeAll()
                        homeViewModelList.append(HomeViewModel())
                    } label: {
                        Image("deleteTabs")
                    }
                    
                    Spacer()
                }
                    .frame(height: 49)
                    .padding(.bottom)
            }
               
                .navigationTitle("Open Tabs")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("vector_black")
                        }
                    }
                }
            
        }

    }
}

//struct TabsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabsView(tabManager: TabManager())
//    }
//}
