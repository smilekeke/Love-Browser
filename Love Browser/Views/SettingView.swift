//
//  SettingView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/28.
//

import SwiftUI
import WebKit

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    @State private var offset = CGSize.zero
    @State private var isSharePresented: Bool = false
    @State var items:[Any] = [URL(string: "itms-apps://itunes.apple.com/cn/app/hitv-browser/id1659403927?")!]
    
    var body: some View {
        
        
        NavigationView {
            
            VStack {
                
                List {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(version ?? "unknow")
                    }
                    
                    
                    NavigationLink {
                       
                        WebViewLoadHtmlView(urlString: "https://pages.flycricket.io/love-browser/terms.html")
                            .navigationTitle("Terms of Use")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        
                        HStack {
                            Text("Terms of Use")
                        }
                        
                    }

                    
                    NavigationLink {
                        
                        WebViewLoadHtmlView(urlString: "https://pages.flycricket.io/love-browser/privacy.html")
                            .navigationTitle("Privacy Policy")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        
                        HStack {
                            Text("Privacy Policy")

                        }
                        
                    }
                    
                    Button {
                        UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/cn/app/hitv-browser/id1659403927?action=write-review")!)
                        
                    } label: {
                    
                        HStack {
                            Text("Rate App")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }.buttonStyle(.plain)
                    
                    Button {
                       
                        isSharePresented = true
                     
                    } label: {
                        
                        HStack {
                            Text("Share App")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        
                    }.buttonStyle(.plain)
                    .sheet(isPresented: $isSharePresented,
                        onDismiss: {
                            print("Dismiss")
                        }, content: {
                            //share sheet
                            ShareSheet(items: $items)
                        }
                    )
                    
                }
            }
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("vector_black")
                    }
                }
                
            }
        }
        .gesture( DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
            }
            .onEnded { _ in
                if offset.width > 50 {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    offset = .zero
                }
            })
    }
}

struct ShareSheet:UIViewControllerRepresentable {
    //你想分享的数据
   @Binding var items:[Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
