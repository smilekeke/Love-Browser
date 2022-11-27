//
//  HomeViewModel.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/27.
//

import Foundation
import SwiftUI

class HomeViewModel : ObservableObject {
    
    let uid: String = UUID().uuidString
    
    @Published var isDesktop = true
    
    let webViewModel = WebViewModel()
    
    var previewImage: UIImage = UIImage(named: "bg1")!
    
    func updateUrl(url: String) {
        isDesktop = url.isEmpty
        
        webViewModel.loadUrl(urlString: url)
    }
}
