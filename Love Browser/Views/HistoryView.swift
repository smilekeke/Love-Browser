//
//  HistoryView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/7.
//

import SwiftUI
import CryptoKit

struct HistoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State private var presentAlert = false
    
    
    @FetchRequest(fetchRequest: SearchHistoryCategory.all) private var searchHistoryCategorys:FetchedResults<SearchHistoryCategory>

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if searchHistoryCategorys.count == 0 {
                    
                    Image("placeHolderImage")
                        .padding(.horizontal)
                    Text(" No browsing record")
                    
                } else {
                    
                    List {
                        
                        let groupByCategory = Dictionary(grouping: searchHistoryCategorys) { (SearchHistoryCategory) in
        
                            return SearchHistoryCategory.date
                        }
                        
                        ForEach(Array(groupByCategory.keys),id: \.self) { section in
                            
                            let searchHistorys =  groupByCategory[section]!
                            
                            Section {

                                ForEach(searchHistorys) { searchHistoryCategory in

                                    HStack {
                                        Image("history")
                                        Text(searchHistoryCategory.title ?? "")
                                    }

                                }

                            } header: {
                                
                                Text(dateIsToday(date: section))
                            
                            }
                            
                        }
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
                
            }
                .navigationTitle("History")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("vector_black")
                        }
                    }
                
                    ToolbarItem(placement: .navigationBarTrailing) {
                    
                        Button {
                            
                            presentAlert = true
                            
                        } label: {
                            Image("delete")
                        }
                        .alert(isPresented: $presentAlert) {
                            Alert(
                                title: Text("Clear all history？"),
                                message: Text(""),
                                primaryButton: .default(Text("Cancle"), action: {
                                    
                                }),
                                secondaryButton: .destructive(Text("Delete"), action: {
                                    //删除浏览历史
                                    deleteAllHistory()
                                })
                            )
                        }
                
                   
                    }
                
                }
            
        }
        
    }
    
    func dateIsToday(date: String?) -> String {
        
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        
        if date == formatter1.string(from: Date.now) {
            return "Today"
        }
        
        return date ?? "date is gone"
    }
    
    func deleteAllHistory()  {
        
        for history in searchHistoryCategorys {
            
            viewContext.delete(history)
        }
        
        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
    }
}
