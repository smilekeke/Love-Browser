//
//  HomePageItemModel.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/14.
//

import SwiftUI
import CoreData


struct HomePageItemModel {
    
    let title: String
    var image: String
    let icon: String
    let link: String
    
    init(title: String, image: String, icon: String, link: String) {
        
        self.title = title
        self.image = image
        self.icon = icon
        self.link = link
    }
}

