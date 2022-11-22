//
//  Love_BrowserApp.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/7.
//

import SwiftUI
import CryptoKit

@main

struct Love_BrowserApp: App {

    var body: some Scene {
       
        WindowGroup {
            
            ContentView()
                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)

            
        }
    }
    
}
