//
//  SettingView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/28.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        
        
        NavigationView {
            
            VStack {
                
                List {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(version ?? "unknow")
                    }
                    
                }
            }
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("vector_black")
                    }
                }
                
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
