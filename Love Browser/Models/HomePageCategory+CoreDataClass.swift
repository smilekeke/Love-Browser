//
//  HomePageCategory+CoreDataClass.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import Foundation
import CoreData

@objc(HomePageCategory)

public class HomePageCategory: NSManagedObject {
    
    static var all: NSFetchRequest<HomePageCategory> {
        let request = HomePageCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        return request
    }
    
    
}
