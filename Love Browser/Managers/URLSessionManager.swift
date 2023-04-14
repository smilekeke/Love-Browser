//
//  URLSessionManager.swift
//  Love Browser
//
//  Created by 豆子 on 2023/4/13.
//

import SwiftUI
import Combine

class URLSessionManager: ObservableObject {
    
    @Published var results: [SegmentModel] = []
    
    init() {
       
        fetchData()
    }

    func fetchData() {
    
       guard let url = URL(string: "http://8.217.76.250:8080/viewconfig") else { return }
       URLSession.shared.dataTask(with: url) { (data, response, error) in
          
           if error == nil {
               
               let decoder = JSONDecoder()
    
               if let data = data {
                   do {
                       var results = try decoder.decode([SegmentModel].self, from: data)
                       DispatchQueue.main.async {
                           
                           results.insert(SegmentModel(label: "Home", items: [], isSelected: true), at: 0)
                           self.results = results
                        
                           print("data is ok")
                        }

                    } catch {
                        self.results = [SegmentModel(label: "Home", items: [], isSelected: true)]
                        print(error)
                    }
                }
           } else {
               
               self.results = [SegmentModel(label: "Home", items: [], isSelected: true)]
           }

       }.resume()
    }

}
