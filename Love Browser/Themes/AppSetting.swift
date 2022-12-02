//
//  AppSetting.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/23.
//

import SwiftUI

class AppSetting: ObservableObject {
    
    @Published var darkModeSettings: Bool = (UserDefaults.standard.string(forKey: "SelectedWallpaper") == "default" || UserDefaults.standard.string(forKey: "SelectedWallpaper") == nil) ? true : false {
        
        didSet {
            
//            let scenes = UIApplication.shared.connectedScenes
//            let windowScene = scenes.first as? UIWindowScene
//            let window = windowScene?.windows.first
//
//            if self.darkModeSettings {
//                window?.overrideUserInterfaceStyle = .light
//            } else {
//                window?.overrideUserInterfaceStyle = .dark
//            }

        }
    }
}
