//
//  HomePageView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/7.
//

import SwiftUI

struct HomePageView: View {

    @EnvironmentObject var appSettings: AppSetting
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: HomePageCategory.all) private var  homePgaeCategorys:FetchedResults<HomePageCategory>
    @Binding var tvViewModel: [ListModel]
    @State private var scale: CGFloat = 1.0
//    @State private var rotation: CGFloat = 0.0
    @State  var longPressTap = false
    
    var clickHomePageItem: (String) -> Void
    var clickCancleButton:() -> Void
    var clickTVListItem: (ListModel) -> Void
    
    let rows = [GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80))]
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                ScrollView {
                    
                    LazyVGrid(columns: rows, spacing: 20) {
                        
                        ForEach(homePgaeCategorys, id: \.title) { homePageCategory in
                            
                            VStack {
                                
                                HStack {
                                    
                                    NavigationLink {
                                        
                                    } label: {
                                        
                                        Button {
                                            
                                        } label: {
                                            
                                            if homePageCategory.image != nil && homePageCategory.image != "" {
                                                Image(homePageCategory.image!)
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 30, height: 30)
                                                
                                            } else {
                                                
                                                
                                                AsyncImage(url: URL(string: homePageCategory.icon?.appendedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://www.google.com/favicon.ico")) { image in
                                                    
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
                                        .scaleEffect(longPressTap ? scale : 1.0)
                                        //                                    .transition(.scale(scale: longPressTap ? scale : 1.0))
                                        //                                    .rotationEffect(.degrees(longPressTap ? rotation : 0.0))
                                        .animation(longPressTap ? Animation.easeInOut(duration: 3).repeatForever(autoreverses: true).speed(20) : Animation.default, value: longPressTap)
                                        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                                            .onEnded { _ in
                                                longPressTap = true
                                                scale = 1.1
                                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                            })
                                    }
                                    
                                    
                                    Button(action: {
                                        
                                        
                                    }, label: {
                                        
                                        Image("deleteHomeItem")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 16, height: 16)
                                            .padding(.top, -14)
                                        
                                    })
                                    .buttonStyle(BorderlessButtonStyle())
                                    .frame(width: 32, height: 32)
                                    .padding(.leading, -24)
                                    .padding(.top, -30)
                                    .opacity(longPressTap ? (homePageCategory.title == "Wallpaper" ? 0 : 1) : 0)
                                    
                                }
                                
                                Text(homePageCategory.title ?? "")
                                    .foregroundColor(appSettings.darkModeSettings ? Color.lb_black : Color.white)
                                    .font(.system(size: 12).weight(.medium))
                                    .lineLimit(1)
                                    .padding(.leading, -12)
                                
                            }
                            .highPriorityGesture(TapGesture()
                                .onEnded { _ in
                                    if longPressTap {
                                        longPressTap.toggle()
                                        if  homePageCategory.title != "Wallpaper" {
                                            deleteSelectedItem(homePageCategory: homePageCategory)
                                        }
                                        
                                    } else {
                                        clickHomePageItem(homePageCategory.link ?? "")
                                    }
                                })
                            
                        }
                    }
                    .padding(.top, 10)
                }
                .onTapGesture {
                    longPressTap = false
                    // 隐藏键盘
                    clickCancleButton()
                }
                .padding(.top, 5)
                
            }
            .opacity(tvViewModel.count != 0 ? 0 : 1)
            
            TVListView(items: $tvViewModel) { listModel in
                
                clickTVListItem(listModel)
            }
            .background(Color.white.opacity(appSettings.darkModeSettings ? 1 : 0))
            .opacity(tvViewModel.count != 0 ? 1 : 0)
            
        }
    }
    
    
    func deleteSelectedItem(homePageCategory: HomePageCategory) -> () {

        viewContext.delete(homePageCategory)

        do {

            try viewContext.save()

        } catch {

            print(error)
        }
        
    }
}

//struct HomePageView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        HomePageView() { query  in
//
//        } clickCancleButton: {
//
//        }
//    }
//}


