//
//  BookMarkCategory+CoreDataClass.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/16.
//

import Foundation
import CoreData

@objc(BookMarkCategory)

public class BookMarkCategory: NSManagedObject {
    
    static var all: NSFetchRequest<BookMarkCategory> {
        let request = BookMarkCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        return request
    }
    
    
}
