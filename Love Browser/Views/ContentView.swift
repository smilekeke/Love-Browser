//
//  ContentView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/6.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @ObservedObject var webViewModel = WebViewModel()
    
    @State private var text = ""
    @State private var isSearch = false
    @State private var canBack = false
    @State private var canForward = false
    @State private var showHome = false

//    @Environment(\.managedObjectContext) private var viewContext
//
//    private func saveHomePageCategory(itemModel: ItemModel) {
//
//        let homePageCategory = HomePageCategory(context: viewContext)
//        homePageCategory.title = itemModel.title
//        homePageCategory.icon = itemModel.icon
//        homePageCategory.link = itemModel.link
//
//        do {
//
//            try viewContext.save()
//
//        } catch {
//
//            print(error)
//        }
//
//    }
//
//    func  saveHomePageData() {
//        saveHomePageCategory(itemModel: ItemModel(title: "FaceBook", icon: "faceBook", link: "https://www.facebook.com/"))
//        saveHomePageCategory(itemModel: ItemModel(title: "Instagram", icon: "instagram", link: "https://www.instagram.com/"))
//        saveHomePageCategory(itemModel: ItemModel(title: "Twitter", icon: "twitter", link: "https://twitter.com/"))
//        saveHomePageCategory(itemModel: ItemModel(title: "Zoom", icon: "zoom", link: "https://zoom.com/"))
//    }
    

    var body: some View {
        
        NavigationView {
            
            VStack {
   
                if isSearch {

                    HomeWebView(text: $text)

                } else {

                    HomePageView() { query in
                        // 跳转到网页
                        text = query
                        isSearch = true
                        showHome = true
                    }

                    .background(
                        Image("bg1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    )
                    .padding(.top,10)
                }
                
                BottomBar(clickHomeButton: {
                    
                    isSearch = false
                    showHome = false
                    
                }, clickBackButton: {
    
                    
                }, clickForwardButton: {
                    
                }, canBack: $canBack, canForward: $canForward, showHome: $showHome)
            }
        }
        .padding(.top, -130)

    }
    
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        
        ContentView().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
    }
           
}


