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
    
    let imageWidth = (UIScreen.main.bounds.width - 45) / 2
    
    var body: some View {
        
        let rows = [GridItem(.fixed(imageWidth)), GridItem(.fixed(imageWidth))]
        
        Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            .onTapGesture {
                
                presentationMode.wrappedValue.dismiss()
            }
        
        Text("Wallpaper")
        
        ScrollView {
            
            LazyVGrid(columns: rows, spacing: 15) {
       
                ForEach(1...10, id: \.self) { value in
                    
                    Button {
                        
                        // 切换壁纸
                        changeWallpaper("bg"+String(value))
                        presentationMode.wrappedValue.dismiss()
                        
                        
                    } label: {
                        
                        Image("bg"+String(value))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageWidth, height: 218)
                            .overlay(alignment: .bottom) {
                                Caption()
                            }
                            
                    }
                        .frame(width: imageWidth, height: 218)
                        .cornerRadius(12)
                    

                }
            }
            .padding(.top,24)
            .background(Color.white)
    
        }
    
    }
}

struct Caption: View {
    var body: some View {

        Text("正在使用")
            .padding()
            .foregroundColor(Color.white)
            .background(Color.black.opacity(0.75),
                        in: RoundedRectangle(cornerRadius: 10.0, style: .continuous))

    }
}

struct WallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperView { str in
            
        }
    }
}
