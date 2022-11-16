//
//  HistoryView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/7.
//

import SwiftUI


enum Sections: String, CaseIterable {
    case today = "today"
    case time = "2022/11/7"
}

struct HistoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(fetchRequest: SearchHistoryCategory.all) private var  searchHistoryCategorys:FetchedResults<SearchHistoryCategory>
    
    var body: some View {
        
        NavigationView {
           
            
            List {
                
                let groupByCategory = Dictionary(grouping: searchHistoryCategorys) { (SearchHistoryCategory) in
                    
                    return SearchHistoryCategory.date
                }
                
                ForEach(Sections.allCases, id: \.self) { key in

                    Section {

                        ForEach(searchHistoryCategorys) { searchHistoryCategory in

                            HStack {
                                Image("history")
                                Text(searchHistoryCategory.title ?? "")
                            }

                        }

                    } header: {

                        Text(key.rawValue)
                            .background(Color("F4F4F4"))

                    }

                }
                .listRowSeparator(.hidden)
                
            }
            .listStyle(.plain)
            
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("vector")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                       
                    } label: {
                        Image("delete")
                    }
                   
                }
                
            }
            
        }
        
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
