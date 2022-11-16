//
//  SearchHistoryView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import SwiftUI

struct SearchHistoryView: View {
    
    @FetchRequest(fetchRequest: SearchWordsCategory.all) private var  searchWords:FetchedResults<SearchWordsCategory>
    
    var body: some View {
        
        
        List {
            
            ForEach(searchWords, id: \.title) { searchWord in
                HStack {
                    Image("search")
                    Text(searchWord.title ?? "")
                        .foregroundColor(Color("222222"))
                        
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
            }
        }
        .listStyle(.plain)
       
//        .background(Color("F4F4F4"))
        .opacity(searchWords.count == 0 ? 0 : 1)
        
    }
}

struct SearchHIstoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView()
    }
}
