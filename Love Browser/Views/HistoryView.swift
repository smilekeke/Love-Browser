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
                        
        //                let groupByCategory = Dictionary(grouping: searchHistoryCategorys) { (SearchHistoryCategory) in
        //
        //                    return SearchHistoryCategory.date
        //                }
                        
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
                }
                
            }
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
    
    func deleteAllHistory()  {
        
//        viewContext.delete(searchHistoryCategorys)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
    }
}
