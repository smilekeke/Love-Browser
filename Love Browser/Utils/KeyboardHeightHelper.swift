//
//  KeyboardHeightHelper.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/21.
//

import SwiftUI
import Foundation

// 创建 KeyboardHeightHelper类，并且实现ObservableObject接口
class KeyboardHeightHelper: ObservableObject {
    
    // 键盘高度
    @Published var keyboardHeight: CGFloat = 0
    private func listenForKeyboardNotifications() {
        
        // 监听键盘弹出事件
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main) { (notification) in
            guard let userInfo = notification.userInfo,
                let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//                print(keyboardRect.height)
            self.keyboardHeight = keyboardRect.height
            // 通过NotificationCenter把键盘弹出的事件传递出去，SwiftUI可以通过onReceive监听接收到通知。
//            NotificationCenter.default.post(name: .editBegin, object: nil, userInfo: nil)
        }
        // 监听键盘关闭事件
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main) { (notification) in
            self.keyboardHeight = 0
            // 通过NotificationCenter把键盘弹出的事件传递出去，SwiftUI可以通过onReceive监听接收到通知。
//            NotificationCenter.default.post(name: .editEnd, object: nil, userInfo: nil)
        }
    }
    
    init() {
        self.listenForKeyboardNotifications()
    }
}
