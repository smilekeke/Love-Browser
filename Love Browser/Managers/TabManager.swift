//
//  TabManager.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/17.
//

import Foundation

class TabManager  {

    private(set) var model: TabsModel

    private var tabControllerCache = [TabsView]()
    
    init(model: TabsModel) {
        self.model = model
    
//        let index = model.currentIndex
//        let tab = model.tabs[index]
//        if tab.link != nil {
//            let controller = buildController(forTab: tab, inheritedAttribution: nil)
//            tabControllerCache.append(controller)
//        }

//        registerForNotifications()
    }
}
