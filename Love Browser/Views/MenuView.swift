//
//  MenuView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/12.
//

import SwiftUI

struct MenuView: View {
    
    var clickMenuView: (String) -> Void

    @Environment(\.presentationMode) var presentationMode
    
    let height = UIScreen.main.bounds.height
    
    let ItemModels = [MenuItemModel(logo: "menu_history", title: "history"),
                      MenuItemModel(logo: "menu_bookmark", title: "Bookmark"),
                      MenuItemModel(logo: "menu_addbookmark", title: "Add Bookmark"),
                      MenuItemModel(logo: "menu_wallpaper", title: "Wallpaper"),
                      MenuItemModel(logo: "menu_setting", title: "Setting"),
                      MenuItemModel(logo: "menu_quit", title: "Quit")]
    
    let rows = [GridItem(.fixed(120)), GridItem(.fixed(120)), GridItem(.fixed(120))]

    var body: some View {
    
        ZStack {
            
            Color.black.opacity(0.3)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            
            LazyVGrid(columns: rows, spacing: 24) {
                
                ForEach(ItemModels, id: \.title) { item in
                    
                    VStack {
                        
                        Button {
                            
                            clickMenuView(item.title)
                            
                        } label: {
                            
                            Image(item.logo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                            
                        }
                        .frame(width: 56, height: 56)
                        .background(Color.lb_item)
                        .cornerRadius(8)
                        
                        Text(item.title)
                            .foregroundColor(Color.lb_black)
                        
                    }
                    
                }
                
            }
                .frame(height: 267)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.top,(height - 287))
            
        }
            .edgesIgnoringSafeArea(.all)
            .background(BackgroundBlurView())
    
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView { title  in
            
        }
    }
}

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
//        UIVisualEffectView(effect: UIBlurEffect(style: .light))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
            
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct MenuItemModel:Hashable {
    
    let logo: String
    let title: String
}


