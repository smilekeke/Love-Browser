//
//  HomeViewModel.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/27.
//

import Foundation
import SwiftUI
import WebKit

class HomeViewModel : ObservableObject {
    
    let uid: String = UUID().uuidString
    
    @Published var isDesktop = true
    
    let webViewModel = WebViewModel()
    
    var previewImage: UIImage = UIImage(named: "deskview")!
    
    func updateUrl(url: String) {
        isDesktop = url.isEmpty
        
        webViewModel.loadUrl(urlString: url)
    }
    
    func updatePreviewImage() {
        
        if isDesktop  {
            self.previewImage = UIImage(named: "deskview")!
            
        } else {
            
            preparePreview(tabView: webViewModel.webView) { image in
                if (image != nil) {
                    self.previewImage = image!
                }
            }
        }
    }
    
    func preparePreview(tabView: WKWebView, completion: @escaping (UIImage?) -> Void) {
        
        DispatchQueue.main.async {
            
            UIGraphicsBeginImageContextWithOptions(tabView.bounds.size, false, UIScreen.main.scale)

            tabView.drawHierarchy(in: tabView.bounds, afterScreenUpdates: true)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completion(image)
            
        }

    }
}
