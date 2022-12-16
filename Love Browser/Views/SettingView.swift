//
//  SettingView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/28.
//

import SwiftUI
import WebKit

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
                    
                    
                    NavigationLink {
                       
                        WebViewLoadHtmlView(urlString: "https://pages.flycricket.io/love-browser/terms.html")
                            .navigationTitle("Terms of Use")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        
                        HStack {
                            Text("Terms of Use")
                        }
                        
                    }

                    
                    NavigationLink {
                        
                        WebViewLoadHtmlView(urlString: "https://pages.flycricket.io/love-browser/privacy.html")
                            .navigationTitle("Privacy Policy")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        
                        HStack {
                            Text("Privacy Policy")

                        }
                        
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
