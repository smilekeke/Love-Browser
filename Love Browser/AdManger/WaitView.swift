//
//  WaitView.swift
//  Love Browser
//
//  Created by 豆子 on 2023/3/31.
//

import SwiftUI

struct WaitView: View {
    var body: some View {
        
        NavigationView {
            
            VStack {
               
                Image("activeLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.top, -100)

            }
        }
    }
}
