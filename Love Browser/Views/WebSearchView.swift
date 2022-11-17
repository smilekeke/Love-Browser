//
//  WebSearchView.swift
//  mkbrowser
//
//  Created by 豆子 on 2022/11/6.
//

import Foundation
import SwiftUI
import UIKit

struct WebSearchView: View {
    
    @State private var showMore = true
    @State private var showList = false
    
    @Binding var text: String
    
    var loadQuery: (String) -> Void
    var cancleLoadQuery: () -> Void
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
            
        HStack {

            LBTextField(text: $text) {
                
                showMore = false
                
            } textDidChange: {
                showList = true
                showMore = false
                
            } pressReturn: {
                
                showList = false
                showMore = true
                loadQuery(text)
            }

                .frame(height: 44)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            
            HStack(spacing: 5) {
                
                Button {

//                    refrshWebView()

                } label: {

                    Image("refresh")
                }
                    .frame(width: 24, height: 24)
                

                Menu {

                    Button {
                        
                        saveHomePageCategory(itemModel: ItemModel(title: "Twitter", icon: "twitter", link: ""))

                    } label: {
                        Image("addHomePage")
                        Text("Add to Homepage")
                    }

                    Button {

                    } label: {
                        Image("QRCode")
                        Text("Generate QR code")
                    }

                    Button {

                    } label: {

                        HStack{

                            Image("searchOnPage")
                            Text("On page search")
                        }

                    }


                } label: {

                    Image("more")
                }
                    .frame(width: 24, height: 24)

            }
                .padding(.leading, -90)
                .opacity(showMore ? 1 : 0)
        }
        
        if showList {
            SearchHistoryView()
                .padding(.top, -8)
        }
           
      
    }
    
       
    // 添加到首页
    private func saveHomePageCategory(itemModel: ItemModel) {

        let homePageCategory = HomePageCategory(context: viewContext)
        homePageCategory.title = itemModel.title
        homePageCategory.icon = itemModel.icon
        homePageCategory.link = itemModel.link

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }
    
}













