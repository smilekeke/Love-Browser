//
//  TabsView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/12.
//

import SwiftUI
import WebKit

// 标签页面
struct TabsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tabManagerModel: TabManagerModel
    
    @State private var offset = CGSize.zero
    var openNewTabs:() -> Void

    let gridWidth = (UIScreen.main.bounds.width - 45) / 2

    let rows = [GridItem(.fixed((UIScreen.main.bounds.width - 45) / 2)), GridItem(.fixed((UIScreen.main.bounds.width - 45) / 2))]
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                ScrollView {
                    
                    LazyVGrid(columns: rows, spacing: 15) {
                        
                        ForEach(tabManagerModel.list, id: \.uid) { homeViewModel in
                            
                            VStack(spacing: 0) {
                                
                                HStack {
                                
                                    Text((homeViewModel.webViewModel.title == "" ? "首页" : homeViewModel.webViewModel.title!) )
                                        .font(.system(size: 12,weight: .medium ))
                                        .padding(.leading, 8)
                                        .padding(.top, 10)
                                        .frame(height: 30)

                                    Spacer()

                                    Button {

                                        removeAndDismiss(model: homeViewModel)

                                    } label: {

                                        Image("deleteTab")
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    .padding(.top, 10)
                                    .padding(.trailing, 10)
                                    
                                }
                                .background(Color.white)
                            
                                Image(uiImage: (homeViewModel.previewImage))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: gridWidth, height: 204)
                                    .clipped()
                                
                            }
                            .frame(width: gridWidth, height: 234)
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
                .background(Color.lb_history)
                .padding(.top, 1)
                
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
                        
                        removeAndDismiss(model: nil)
                        
                    } label: {
                        Image("deleteTabs")
                    }
                    
                    Spacer()
                }
                    .background(Color.white)
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
            
        }.gesture( DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
            }
            .onEnded { _ in
                if offset.width > 50 {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    offset = .zero
                }
            })

    }
    
    func removeAndDismiss(model: HomeViewModel?) {
    
        if  tabManagerModel.list.count == 1 {
            presentationMode.wrappedValue.dismiss()
        }
        
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
