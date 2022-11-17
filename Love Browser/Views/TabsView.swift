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
    
    let gridWidth = (UIScreen.main.bounds.width - 45) / 2
    
    let tabsModel = [TabsModel(title: "", image: Image("placeHolderImage")),
                     TabsModel(title: "", image: Image("placeHolderImage"))
                    ]
    
    let rows = [GridItem(.fixed((UIScreen.main.bounds.width - 45) / 2)), GridItem(.fixed((UIScreen.main.bounds.width - 45) / 2))]
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                LazyVGrid(columns: rows, spacing: 15) {
           
                    ForEach(tabsModel, id: \.title) { item in
                        
                        VStack {
                            
                            HStack {
                                
                                
                                Text("首页")
                                    .padding(.leading, 8)
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Image("deleteTab")
                                        .frame(width: 16, height: 16)
                                }
                                .padding(.trailing, 8)
                                
                            }
                            .padding(.top,20)
                            
                            Image("placeHolderImage")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: gridWidth,height: 186)
                               
                            }
                            .frame(width: gridWidth, height: 214)
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
