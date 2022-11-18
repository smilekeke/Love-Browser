//
//  SearchWordsView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import SwiftUI

struct SearchWordsView: View {
    
    @FetchRequest(fetchRequest: SearchWordsCategory.all) private var  searchWords:FetchedResults<SearchWordsCategory>
    
    var body: some View {
        
        
        List {
            
            ForEach(searchWords, id: \.title) { searchWord in
                HStack {
                    Image("history")
                    Text(searchWord.title ?? "")
                        .foregroundColor(Color.lb_black)
                        
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
            }
        }
        .listStyle(.plain)
       
        .background(Color("F4F4F4"))
        .opacity(searchWords.count == 0 ? 0 : 1)
        
    }
}

struct SearchWordsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchWordsView()
    }
}
