//
//  TVListView.swift
//  Love Browser
//
//  Created by 豆子 on 2023/4/13.
//

import SwiftUI

struct TVListView: View {
    
    let gridWidth = (UIScreen.main.bounds.width - 45) / 3

    let rows = [GridItem(.fixed((UIScreen.main.bounds.width - 45) / 3)), GridItem(.fixed((UIScreen.main.bounds.width - 45) / 3)), GridItem(.fixed((UIScreen.main.bounds.width - 45) / 3))]
    
    @Binding var items: [ListModel]
    var clickTVListItem: (ListModel) -> Void
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                
                LazyVGrid(columns: rows, spacing: 15) {
                    
                    ForEach(items, id: \.cover) { homeViewModel in
                        
                        VStack(spacing: 0) {
                        
                            AsyncImage(url: URL(string: homeViewModel.cover ?? "")) { image in
                                
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: gridWidth, height: 155)
                                    .clipped()
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(Color.lb_item, lineWidth: 2)
                                    )
                                
                            } placeholder: {
                                
                                Color.white
                            }
                            
                            Text(homeViewModel.title ?? "")
                                .lineLimit(1)
                                .font(.system(size: 12))
                                .foregroundColor(Color.lb_black)
                                .padding(.top, 10)
                               
                            
                        }
                        .frame(width: gridWidth, height: 185)
                        .onTapGesture {
                            clickTVListItem(homeViewModel)
                        }
                        
                    }
                }
                .padding(.top, 5)
                
            }
            .background(Color.white)
            .padding(.top, 1)
            
        }
    }
}

//struct TVListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TVListView()
//    }
//}
