//
//  CoreDataManager.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/14.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {

        persistentContainer = NSPersistentContainer(name: "DataBase")
        persistentContainer.loadPersistentStores { description, error in
            
            if let error = error {
                
                    fatalError("Unable to load Core Data Model (\(error)")
            }
        }
    }
    
    
}
