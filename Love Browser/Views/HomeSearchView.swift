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
    
    @ObservedObject var textFieldManger = TextFieldManger()
    
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
                    textFieldManger.resignFirstResponder()

                }, label: {
                    Image("vector")
                        .padding(.leading, 20)
                        
                })
                    .opacity(showBack ? 1 : 0)
                    
                LBTextField(text: $text, textField: textFieldManger.textField) {
                    
                    showBack = true
                    showSearchIcon = false
                    
                } textDidChange: {
                    DispatchQueue.main.async {
                        showBack = true
                        showSearchIcon = false
                    }
                } pressReturn: {
                    
                    jumpToHomeWebView(text)
                   
                    saveSearchWord(title: text, url: "")
                    showBack = false
                    showSearchIcon = true
                }
                    .frame(height: 44)
                    .padding(.leading,showBack ? 0 : -10)
                    .padding(.trailing, 20)
                    
                HStack {
                    
                    Button(action: {
                
                    }, label: {
                        Image("search_black")
                    
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
