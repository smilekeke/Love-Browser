//
//  TabsModel.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/22.
//

import SwiftUI
import WebKit


struct TabsModel {
    
//    var uid: String
    var homeWebView: HomeWebView
    var image: UIImage
    
    init( homeWebView: HomeWebView, image: UIImage) {
        
        self.homeWebView = homeWebView
        self.image = image
        
    }
}

