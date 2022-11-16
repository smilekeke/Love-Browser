//
//  HomeSearchView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import SwiftUI

struct HomeSearchView: View {

    @State private var text = ""
    @State private var showBack = false
    @State private var showSearchIcon = true
    

    var jumpToHomeWebView: (String) -> Void
    
    @Environment(\.managedObjectContext) private var viewContext

    private func saveSearchWord(title: String, url: String) {

        let searchWordsCategory = SearchWordsCategory(context: viewContext)
        searchWordsCategory.title = title
        searchWordsCategory.url = url

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }

    
    var body: some View {
        
            HStack {
                
                Button(action: {
                    
                    text = ""
                    showBack = false
                    showSearchIcon = true

                }, label: {
                    Image("vector")
                        .padding(.leading, 10)
                })
                    .opacity(showBack ? 1 : 0)

                LBTextField(text: $text) {
                    showBack = true
                    showSearchIcon = false
                    
                } textDidChange: {
                    
                    showBack = true
                    showSearchIcon = false
                    
                } pressReturn: {
                    
                    jumpToHomeWebView(text)
                   
                    saveSearchWord(title: text, url: "")
                    showBack = false
                    showSearchIcon = true
                 }
                

                    .frame(height: 44)
                    .padding(.trailing, 20)
                
                    
                HStack {
                    
                    Button(action: {
                
                    }, label: {
                        Image("searchIcon")
                    
                    })
                        .opacity(showSearchIcon ? 1 : 0)
                    
                }
                    .frame(width: 16, height: 16)
                    .padding(.leading, -60)
                    
            }

    }
}


struct HomeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        
        HomeSearchView { text in
                
        }.environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
    }
}
