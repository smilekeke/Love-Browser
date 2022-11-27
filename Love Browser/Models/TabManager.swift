//
//  TabManager.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/27.
//

import Foundation
import SwiftUI
import Combine


class TabManagerModel : ObservableObject {

    @Published var list: Array<HomeViewModel>
    
    @Published var curUid : String
    
    @Published var canBack: Bool = false
    @Published var canForward: Bool = false

    init() {
        self.list = []
        self.curUid = ""
    }
    
    func getCurIndex() -> Int {
        return list.firstIndex { item in
            item.uid == curUid
        }!
    }
    
    func addTab(newModel: HomeViewModel = HomeViewModel()) {
        newModel.webViewModel.$canGoBack
            .filter({ Bool in
                newModel.uid == self.curUid
            })
            .assign(to: &self.$canBack)
        
        newModel.webViewModel.$canGoForward
            .filter({ Bool in
                newModel.uid == self.curUid
            })
            .assign(to: &self.$canForward)
        
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

class CustomSubscriber: Subscriber {
    
    // 指定接收值的类型与失败的类型
    typealias Input = Int
    typealias Failure = Never
    
    // Publisher会首先调用该方法
    func receive(subscription: Subscription) {
        // 接收订阅的值的最大量，通过.max来设置最大值，.unlimited则为不设限
        subscription.request(.max(6))
    }
    
    // 接收到值时调用的方法，返回接收值最大个数的变化
    func receive(_ input: Int) -> Subscribers.Demand {
        
        print("Received value", input)
        
        return .none
    }
    
    // 实现接收完成事件的方法
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion", completion)
    }
}
