//
//  TabManager.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/27.
//

import Foundation
import SwiftUI

class TabManagerModel : ObservableObject {

    @Published var list: Array<HomeViewModel>
    
    @Published var curUid : String

    init(list: [HomeViewModel] = [HomeViewModel()]) {
        self.list = list
        self.curUid = list.first!.uid
    }
    
    func getCurIndex() -> Int {
        return list.firstIndex { item in
            item.uid == curUid
        }!
    }
    
    func addTab(newModel: HomeViewModel = HomeViewModel()) {
        list.append(newModel)
        
        selectTab(targetModel: newModel)
    }
    
    func removeTab(targetModel: HomeViewModel?) {
        list.removeAll { item in
            targetModel == nil || targetModel === item
        }
        
        if list.isEmpty {
            addTab()
        }
        
        if !list.contains(where: { item in
            item.uid == curUid
        }) {
            selectTab(targetModel: list.last!)
        }
    }
    
    func selectTab(targetModel: HomeViewModel) {
        curUid = targetModel.uid
    }
    
}
