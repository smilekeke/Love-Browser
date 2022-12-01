//
//  WallpaperView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/12.
//

import SwiftUI

struct WallpaperView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var changeWallpaper: (String) -> Void
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        let rows = [GridItem(.fixed((screenWidth - 45) / 2)), GridItem(.fixed((screenWidth - 45) / 2))]
        
        NavigationView {
            
            ZStack {
                
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                
                
                ScrollView {
                    
                    Text("Wallpaper")
                        .padding(.top, 15)
                    
                    LazyVGrid(columns: rows, spacing: 15) {
                        
                        ForEach(1...10, id: \.self) { value in
                            
                            Button {
                                
                                // 切换壁纸
                                changeWallpaper("bg"+String(value))
                                UserDefaults.standard.set("bg"+String(value), forKey: "SelectedWallpaper")
                                presentationMode.wrappedValue.dismiss()
                                
                                
                            } label: {
                                
                                Image("bg"+String(value))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: (screenWidth - 45) / 2, height: 218)
                                
                            }
                            .frame(width: (screenWidth - 45) / 2, height: 218)
                            .cornerRadius(12)
                            .background(Color.white)
                            
                        }
                    }
                    .padding(.top, 20)

                    
                    Button {
                        
                        changeWallpaper("default")
                        UserDefaults.standard.set("default", forKey: "SelectedWallpaper")
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        
                        Text("Defaut")
                            .frame(width: screenWidth-40, height: 40, alignment: .center)
                        
                    }
                    
                    .background(Color.lb_item)
                    .foregroundColor(Color.lb_black)
                    .cornerRadius(8.0)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                }
                .frame(height: 470)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.top,(screenHeight - 470))
                
            }
            .edgesIgnoringSafeArea(.all)
            .background(BackgroundBlurView())
        }
        .background(BackgroundBlurView())
    
    }
}

struct Caption: View {
    var body: some View {

        Text("正在使用")
            .padding()
            .foregroundColor(Color.white)
//            .background(Color.black.opacity(0.75),
//                        in: RoundedRectangle(cornerRadius: 10.0, style: .continuous))

    }
}

struct WallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperView { str in
            
        }
    }
}
