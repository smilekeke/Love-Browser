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
        
        return request
    }
    
}
