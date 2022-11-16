//
//  HomePageModelManager.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/14.
//

import SwiftUI
import CoreData


//struct HomePageModelManager: View {
//
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
//
//    var body: some View {
//
//        Text("")
//    }
//
//}

//struct HomePageModelManager_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        HomePageModelManager().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
//    }
//           
//}



struct ItemModel {
    
    let title: String
    let icon: String
    let link: String
    
    init(title: String, icon: String, link: String) {
        
        self.title = title
        self.icon = icon
        self.link = link
    }
}

