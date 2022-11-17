//
//  BookMarkView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/12.
//

import SwiftUI

struct BookMarkView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var presentAlert = false
    
    @FetchRequest(fetchRequest: BookMarkCategory.all) private var  bookMarkCategorys:FetchedResults<BookMarkCategory>
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if bookMarkCategorys.count == 0 {
                    
                    Image("placeHolderImage")
                        .padding(.horizontal)
                    Text(" No browsing record")
                    
                } else {
                    
                    List {

                        ForEach(bookMarkCategorys) { bookMarkCategory in

                            HStack {
                                Image("bookmark")
                                Text(bookMarkCategory.title ?? "")
                            }

                        }
                        .listRowSeparator(.hidden)

                    }
                    
                    .listStyle(.plain)
                }
            }
                .navigationTitle("bookmark")
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
                                title: Text("Clear all bookmark？"),
                                message: Text(""),
                                primaryButton: .default(Text("Cancle"), action: {
                                    
                                }),
                                secondaryButton: .destructive(Text("Delete"), action: {
                                    //删除所有书签
                                    deleteAllBookMark()
                                })
                            )
                        }

                    }

                }
        }
    
    }
    
    func deleteAllBookMark()  {
        
//        viewContext.delete(searchHistoryCategorys)
    }
}

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookMarkView()
    }
}
