//
//  BookMarkView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/12.
//

import SwiftUI

struct BookMarkView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
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
                .navigationTitle("BookMark")
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

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookMarkView()
    }
}
