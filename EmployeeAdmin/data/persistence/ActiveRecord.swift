//
//  ActiveRecord.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

public enum ActiveRecordError: Error {
  case missingContext
}

public protocol ActiveRecord where Self: NSManagedObject {
  
}

public extension ActiveRecord {
  
  static func findAll(in context: NSManagedObjectContext) throws -> [Self] {
    let request = fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    return try context.fetch(request) as! [Self]
  }
  
  static func findAll(matching predicate: NSPredicate?, sortedBy sortDescriptors: [NSSortDescriptor]? = nil, in context: NSManagedObjectContext) throws -> [Self] {
    let request = fetchRequest()
    request.predicate = predicate
    request.sortDescriptors = sortDescriptors
    
    return try context.fetch(request) as! [Self]
  }
  
  static func find(byID id: Int64, in context: NSManagedObjectContext) throws -> Self? {
    let request = fetchRequest()
    request.predicate = NSPredicate(format: "id == %d", id)
    request.fetchLimit = 1
    
    return try context.fetch(request).first as? Self
  }
  
  static func find(byIDs ids: [Int64], in context: NSManagedObjectContext) throws -> [Self] {
    guard !ids.isEmpty else {
      return []
    }
    
    let request = fetchRequest()
    request.predicate = NSPredicate(format: "id IN %@", ids)
    
    return try context.fetch(request) as? [Self] ?? []
  }
  
  static func find(byPredicate predicate: NSPredicate, in context: NSManagedObjectContext) throws -> Self? {
    let request = fetchRequest()
    request.predicate = predicate
    
    return try context.fetch(request).first as? Self
  }
  
  func save() throws {
    guard let context = managedObjectContext else {
      throw ActiveRecordError.missingContext
    }
    
    guard context.hasChanges else {
      return
    }
    
    try context.save()
  }
  
  func delete() throws {
    guard let context = managedObjectContext else {
      throw ActiveRecordError.missingContext
    }
    
    context.delete(self)
    
    guard context.hasChanges else {
      return
    }
    
    try context.save()
  }
  
  static func count(in context: NSManagedObjectContext) throws -> Int {
    try context.count(for: fetchRequest())
  }
  
}
