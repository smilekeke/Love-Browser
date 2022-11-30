//
//  Color+Extentions.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/18.
//

import SwiftUI


public extension Color {
    
    static let lb_gray = Color.init(0x919191)
    static let lb_black = Color.init(0x222222)
    static let lb_item = Color.init(0xF5F5F7)
    static let lb_history = Color.init(0xF4F4F4)
    static let lb_section = Color.init(0x666666)
    
}

private extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
