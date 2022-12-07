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
    var openQRCodeView:() -> Void
    
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
          
            HStack {
                
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
                
                if showSearchIcon || (textFieldManger.textField.isFirstResponder && text != "") {
                    
                    ZStack {
                        
                        Button(action: {
                            
                        }, label: {
                            
                            Image(appSettings.darkModeSettings ? "search_black" : "search_white")
                            
                        }).opacity(showSearchIcon ? 1 : 0)
                        
                        Button(action: {
                            text = ""
                            
                        }, label: {
                            
                            Image(appSettings.darkModeSettings ? "clearIcon_black" : "clearIcon_white")
                            
                        }).opacity(showSearchIcon ? 0 : 1)
                        
                    }
                    .frame(width: 16, height: 16)
                    .padding(.trailing, 10)
                }
                
                if showMore {
                    
                    HStack(spacing: 5) {
                        
                        Button {
                            
                            refreshWebView()
                            
                        } label: {
                            
                            Image(appSettings.darkModeSettings ? "refresh" : "refresh_white")
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
                                
                                openQRCodeView()
                                
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
                            
                            Image(appSettings.darkModeSettings ? "more" : "more_white")
                        }
                        .frame(width: 24, height: 24)
                        
                    }
                    .background(appSettings.darkModeSettings ? Color.white : Color.clear)
                    .padding(.trailing, 10)
                }
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(appSettings.darkModeSettings ? Color.black : Color.white, lineWidth: 2)
            )
            .padding(.leading, showBack ? 0 : -20)
            .padding(.trailing, 20)
        }
        
        .environmentObject(appSettings)

    }
    
    private func saveSearchWord(title: String) {
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let searchWordsCategory = SearchWordsCategory(context: viewContext)
        searchWordsCategory.title = title
        searchWordsCategory.date = Date()

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
