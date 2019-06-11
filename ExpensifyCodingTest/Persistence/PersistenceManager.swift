//
//  PersistenceManager.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 11/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoreData

public final class PersistenceManager {
  
  private init() {}
  
  static let shared = PersistenceManager()
  
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "ExpensifyCodingTest")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  public lazy var context: NSManagedObjectContext = {
    return persistentContainer.viewContext
  }()
  
  
  func save() {
    
    if context.hasChanges {
      
      do {
        try context.save()
      } catch let error {
        
        let nserror = error as NSError
        fatalError("Unresolved error: \(nserror), \(nserror.userInfo)")
        
      }
      
    }
    
  }
  
}
