//
//  ContentView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/6.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @StateObject var webViewModel = WebViewModel()
    
    @State private var text = ""
    @State private var isSearch = false
    @State private var backgroundImage = "default"
    

    @Environment(\.managedObjectContext) private var viewContext

    private func saveHomePageCategory(itemModel: HomePageItemModel) {

        let homePageCategory = HomePageCategory(context: viewContext)
        homePageCategory.title = itemModel.title
        homePageCategory.icon = itemModel.icon
        homePageCategory.link = itemModel.link

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }

    func  saveHomePageData() {
        saveHomePageCategory(itemModel: HomePageItemModel(title: "FaceBook", icon: "faceBook", link: "https://www.facebook.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Instagram", icon: "instagram", link: "https://www.instagram.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Twitter", icon: "twitter", link: "https://twitter.com/"))
        saveHomePageCategory(itemModel: HomePageItemModel(title: "Zoom", icon: "zoom", link: "https://zoom.com/"))
    }
    

    var body: some View {
        
        NavigationView {
            
            VStack {
   
                if isSearch {

                    HomeWebView(text: $text, isSearch: $isSearch, backgroundImage: $backgroundImage)

                } else {

                    HomePageView(backgroundImage: $backgroundImage) {  query in
                        // 跳转到网页
                        text = query
                        isSearch = true
                    }

                    .background(
                        Image(backgroundImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                    )
                }

            }
            
            .navigationBarHidden(true)
            
        }
        .onAppear {
            
            if !UserDefaults.standard.bool(forKey: "WriteHomePageData") {
                saveHomePageData()
            }
            UserDefaults.standard.set(true, forKey: "WriteHomePageData")
        }

    }
    
    
    func preparePreview(completion: @escaping (UIImage?) -> Void) {

        DispatchQueue.main.async {
            
            let webView = webViewModel.webView

             UIGraphicsBeginImageContextWithOptions(webView.bounds.size, false, UIScreen.main.scale)

             webView.drawHierarchy(in: webView.bounds, afterScreenUpdates: true)

             let image = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()
             completion(image)
        }

    }
    
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        
        ContentView().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
    }
           
}


