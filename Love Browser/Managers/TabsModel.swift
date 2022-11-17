//
//  TabsModel.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/17.
//

import Foundation
import CoreData
import SwiftUI

public class TabsModel {
    
    var title: String
    var image: Image

    init(title: String, image: Image) {
        
        self.title = title
        self.image = image
    }
}
