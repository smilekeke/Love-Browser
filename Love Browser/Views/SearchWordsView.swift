//
//  SearchWordsView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import SwiftUI

struct SearchWordsView: View {
    
    var closeSearchWordsView: () -> Void
    var reloadWebView: (String) -> Void
    @EnvironmentObject var appSettings: AppSetting
    
    @FetchRequest(fetchRequest: SearchWordsCategory.all) private var  searchWords:FetchedResults<SearchWordsCategory>
    
    var body: some View {

        VStack{
            
            List {
                
                ForEach(searchWords, id: \.title) { searchWord in
                
                        Button {
                            
                            reloadWebView(searchWord.title ?? "")
                            
                        } label: {
                            
                            HStack {
                                
                                Image("history")
                                
                                Text(searchWord.title ?? "")
                                    .foregroundColor(appSettings.darkModeSettings ? Color.lb_black : Color.white)
                                    .frame(width: UIScreen.main.bounds.width-40, height: 40,alignment: .leading)
                            }
                
                        } 
                        .frame(width: UIScreen.main.bounds.width, height: 40,alignment: .leading)
                        .buttonStyle(BorderlessButtonStyle())
                       
                    .listRowBackground(appSettings.darkModeSettings ? Color.white : Color.gray.opacity(0.8))
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)

        }
        .onTapGesture {
            closeSearchWordsView()
        }
    }
}

struct SearchWordsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchWordsView {
            
        } reloadWebView: { str in
            
        }

    }
}
