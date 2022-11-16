//
//  SearchHistoryCategory+CoreDataClass.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/16.
//

import Foundation
import CoreData
import SwiftUI

@objc(SearchHistoryCategory)

public class SearchHistoryCategory: NSManagedObject {
    
    static var all: NSFetchRequest<SearchHistoryCategory> {
        let request = SearchHistoryCategory.fetchRequest()
        request.entity = SearchHistoryCategory.entity()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        return request
    }
    
    
}
