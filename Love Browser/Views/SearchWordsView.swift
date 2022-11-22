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
    
    @FetchRequest(fetchRequest: SearchWordsCategory.all) private var  searchWords:FetchedResults<SearchWordsCategory>
    
    var body: some View {

        VStack{
            
            List {
                
                ForEach(searchWords, id: \.title) { searchWord in
                
                    HStack {
                        Image("history")
                        Text(searchWord.title ?? "")
                            .foregroundColor(Color.lb_black)
                            .frame(width: UIScreen.main.bounds.width-40, height: 40,alignment: .leading)
                            .background(Color.white)
                    }
                    .highPriorityGesture(
                        TapGesture()
                            .onEnded({ _ in
                                reloadWebView(searchWord.title ?? "")
                            })
                    )
    
                    .listRowBackground(Color.white)
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
