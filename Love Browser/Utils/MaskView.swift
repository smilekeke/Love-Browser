//
//  MaskView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import SwiftUI

//蒙层
struct MaskView : View {
    var bgColor: Color
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
    }
}
