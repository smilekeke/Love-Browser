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
    
    
    let ItemModels = [MenuItemModel(logo: "menu_history", title: "history"),
                      MenuItemModel(logo: "menu_bookmark", title: "Bookmark"),
                      MenuItemModel(logo: "menu_addbookmark", title: "Add Bookmark"),
                      MenuItemModel(logo: "menu_wallpaper", title: "Wallpaper"),
                      MenuItemModel(logo: "menu_setting", title: "Setting"),
                      MenuItemModel(logo: "menu_quit", title: "Quit")]
    
    let rows = [GridItem(.fixed(120)), GridItem(.fixed(120)), GridItem(.fixed(120))]

    var body: some View {
    
        VStack{
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
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
//                .background(Color.blue)
                .edgesIgnoringSafeArea([.bottom])
                .frame(height: 267)
        }
            .background(Color.white)
            .background(RoundedCorners(color: Color.white, tl: 12, tr: 12, bl: 0, br: 0))
//            .background(BackgroundBlurView())

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

struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    var body: some View {
        GeometryReader { geometry in
            Path { path in

                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)

                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }
            .fill(self.color)
        }
    }
}

struct MenuItemModel:Hashable {
    
    let logo: String
    let title: String
}


