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
    
    @EnvironmentObject var tabManagerModel: TabManagerModel
    
    var openNewTabs:() -> Void

    let gridWidth = (UIScreen.main.bounds.width - 45) / 2

    let rows = [GridItem(.fixed((UIScreen.main.bounds.width - 45) / 2)), GridItem(.fixed((UIScreen.main.bounds.width - 45) / 2))]
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                ScrollView {
                    
                    LazyVGrid(columns: rows, spacing: 15) {
                        
                        ForEach(tabManagerModel.list, id: \.uid) { homeViewModel in
                            
                            VStack {
                                
                                HStack {
                                
                                    Text(homeViewModel.webViewModel.title ?? "首页")
                                        .font(.system(size: 12))
                                        .padding(.leading, 8)
                                        .padding(.top, 10)
                                    
                                    Spacer()
                                    
                                    Button {
                                        
                                        removeAndDismiss(model: homeViewModel)
                                        
                                    } label: {
                                        
                                        Image("deleteTab")
                                            .frame(width: 32, height: 32)
                                    }
                                    .buttonStyle(BorderedProminentButtonStyle())
                                    
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
                            .onTapGesture {
                                tabManagerModel.selectTab(targetModel: homeViewModel)
                                presentationMode.wrappedValue.dismiss()
                            }
                            
                        }
                    }
                    .padding(.top,24)
                    
                }
                    .background(Color.lb_item)
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        openNewTabs()
                        
                        
                        
                        
                    } label: {
                        Image("openTabs")
                    }
                    
                    Spacer()
                    
                    Button {
                        
                        removeAndDismiss(model: nil)
                        
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
    
    func removeAndDismiss(model: HomeViewModel?) {
    
        tabManagerModel.removeTab(targetModel: model)
        
        if tabManagerModel.list.isEmpty {
            presentationMode.wrappedValue.dismiss()
        }
    
    }
}

//struct TabsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabsView(tabManager: TabManager())
//    }
//}
