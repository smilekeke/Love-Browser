//
//  ThemeManager.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import SwiftUI

class ThemeManager {
    
    enum ImageSet {
        case light
        case dark
    }
    
    static let shared = ThemeManager()
    
    private var theme :Theme = LightTheme() // Default theme
    
    public func applyTheme(theme: Theme) {
        
        self.theme = theme
    }
    
    public func getTheme() -> Theme {
        return self.theme
    }
    
}
