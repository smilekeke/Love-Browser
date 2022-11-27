//
//  HomeSearchView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import SwiftUI
import CoreData

struct SearchView: View {

    @Binding var text: String
    @Binding var showMore: Bool
    @Binding var showSearchIcon: Bool
    @Binding var showBack:Bool
    
    var textDidChange:() -> Void
    var clickCancleButton:() -> Void
    var changeToWebView: (String) -> Void
    var refreshWebView:() -> Void
    var addToHomePage:() -> Void
    
    var textFieldManger: TextFieldManger
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var appSettings: AppSetting


    
    var body: some View {
       
        HStack {
            
            Button(action: {
                
                text = ""
                showBack = false
                showSearchIcon = true
                textFieldManger.textField.resignFirstResponder()
                clickCancleButton()
                
            }, label: {
                
                if appSettings.darkModeSettings {
                    Image("vector_black")
                        .padding(.leading, 15)
                } else {
                    Image("vector_white")
                        .padding(.leading, 15)
                }
                
            })
            .opacity(showBack ? 1 : 0)
            
            LBTextField(text: $text,textField: textFieldManger.textField) {
                
                showBack = true
                showSearchIcon = false
                showMore = false
                
            } textDidChange: {
                DispatchQueue.main.async {
                    showSearchIcon = false
                }
                textDidChange()
            } pressReturn: {
                
                changeToWebView(text)
                if text !=  "" {
                    saveSearchWord(title: text)
                }
               
                showBack = false
                showMore = true
            }
            
            .frame(height: 44)
            .padding(.leading,showBack ? 0 : -10)
            .padding(.trailing, 15)
            
            HStack {
                
                Button(action: {
                    
                }, label: {
                    if appSettings.darkModeSettings {
                        Image("search_black")
                    } else {
                        Image("search_white")
                    }
                })
                .opacity(showSearchIcon ? 1 : 0)
                
            }
            .frame(width: 16, height: 16)
            .padding(.leading, -60)
            
            if showMore {
                HStack(spacing: 5) {
                    
                    Button {
            
                        refreshWebView()
        
                    } label: {
                        
                        Image("refresh")
                    }
                    .frame(width: 24, height: 24)
                    
                    
                    Menu {
                        
                        Button {
                            
                            addToHomePage()
                        } label: {
                            Image("addHomePage")
                            Text("Add to Homepage")
                        }
                        
                        Button {
                            
                        } label: {
                            Image("QRCode")
                            Text("Generate QR code")
                        }
                        
                        Button {
                            
                        } label: {
                            
                            HStack{
                                
                                Image("searchOnPage")
                                Text("On page search")
                            }
                            
                        }
                        
                        
                    } label: {
                        
                        Image("more")
                    }
                    .frame(width: 24, height: 24)
                    
                }
                .padding(.leading, -90)
            }
            
            
        }.environmentObject(appSettings)

    }
    
    private func saveSearchWord(title: String) {
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let searchWordsCategory = SearchWordsCategory(context: viewContext)
        searchWordsCategory.title = title

        do {

            try viewContext.save()

        } catch {

            print(error)
        }

    }
    
    
}


//struct HomeSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        SearchView(textField:LBTextField(text: <#T##Binding<String>#>, textField: ).environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
//
//    }
//}
