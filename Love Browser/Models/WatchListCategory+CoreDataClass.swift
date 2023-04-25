//
//  WatchListCategory+CoreDataClass.swift
//  Love Browser
//
//  Created by 豆子 on 2023/4/23.
//

import Foundation
import CoreData
import SwiftUI

@objc(WatchListCategory)

public class WatchListCategory: NSManagedObject {
    
    static var all: NSFetchRequest<WatchListCategory> {
        let request = WatchListCategory.fetchRequest()
        request.entity = WatchListCategory.entity()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        request.returnsDistinctResults = true
        
        return request
    }
    
    static func gitItemByTitle(title: String) -> NSFetchRequest<WatchListCategory> {
        let request = WatchListCategory.fetchRequest()
        request.entity = WatchListCategory.entity()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        request.predicate = NSPredicate(format: "title == %@", title)

        return request
    }
    
}
