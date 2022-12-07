//
//  SearchWordsCategory+CoreDataClass.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import Foundation
import CoreData

@objc(SearchWordsCategory)

public class SearchWordsCategory: NSManagedObject {
    
    static var all: NSFetchRequest<SearchWordsCategory> {
        let request = SearchWordsCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        return request
    }
    
}
