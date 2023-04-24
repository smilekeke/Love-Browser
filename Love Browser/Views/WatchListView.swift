//
//  WatchListView.swift
//  Love Browser
//
//  Created by 豆子 on 2023/4/23.
//

import SwiftUI

struct WatchListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State private var offset = CGSize.zero
    var clickWatchListItem: (String) -> Void
    var clickGoToWatchButton: () -> Void
    
    let gridWidth = (UIScreen.main.bounds.width - 45) / 3

    let rows = [GridItem(.fixed((UIScreen.main.bounds.width - 45) / 3)), GridItem(.fixed((UIScreen.main.bounds.width - 45) / 3)), GridItem(.fixed((UIScreen.main.bounds.width - 45) / 3))]
    
    @FetchRequest(fetchRequest: WatchListCategory.all) private var watchListCategorys:FetchedResults<WatchListCategory>
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if watchListCategorys.count == 0 {
                    VStack {
                        Image("placeHolderImage")
                            .padding(.horizontal)
                        Text("No records")
                        
                        Button {
                            clickGoToWatchButton()
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            
                            Text("Go to watch")
                                .frame(width: UIScreen.main.bounds.width - 32, height: 40)
                                .foregroundColor(Color.white)
                        }
                        .background(Color.lb_blue)
                        .cornerRadius(8.0)
                        .padding(.top, 10)
                    }
                    .padding(.top, -110)
                } else {
                    
                    ScrollView {
                        
                        LazyVGrid(columns: rows, spacing: 15) {
                            
                            ForEach(watchListCategorys, id: \.cover) { homeViewModel in
                                
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
                                    clickWatchListItem(homeViewModel.url ?? "")
                                    presentationMode.wrappedValue.dismiss()
                                }
                                
                            }
                        }
                        .padding(.top, 5)
                        
                    }
            
                }
            }
            .navigationTitle("WatchList")
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
        .gesture( DragGesture()
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
}

//struct WatchListView_Previews: PreviewProvider {
//    static var previews: some View {
//        WatchListView()
//    }
//}
