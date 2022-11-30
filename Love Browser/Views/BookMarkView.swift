//
//  BookMarkView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/12.
//

import SwiftUI
import CoreData

struct BookMarkView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State private var presentAlert = false
    
    @FetchRequest(fetchRequest: BookMarkCategory.all) private var bookMarkCategorys:FetchedResults<BookMarkCategory>
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if bookMarkCategorys.count == 0 {
                    
                    Image("placeHolderImage")
                        .padding(.horizontal)
                    Text(" No browsing record")
                    
                } else {
                 
                    ScrollView {
                        
                        LazyVStack(alignment: .leading, spacing: 20, content: {
                                        
                            ForEach(bookMarkCategorys) { bookMarkCategory in
                                
                                HStack {
                                    
                                    Image("bookmark")
                                        .padding(.leading,20)
                                    Text(bookMarkCategory.title ?? "")
                                        .padding(.leading,10)
                                }
                                
                            }
                                        
                        }).padding(.top, 10)
                    }
                }
            }
                .navigationTitle("Bookmark")
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
        
        for bookmark in bookMarkCategorys {
            
            viewContext.delete(bookmark)
        }
        
        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }
}

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookMarkView()
    }
}
