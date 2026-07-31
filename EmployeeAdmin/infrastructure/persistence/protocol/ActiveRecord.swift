//
//  ActiveRecord.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

public protocol ActiveRecord where Self: NSManagedObject {
  
}

public extension ActiveRecord {
  
  static func findAll(in context: NSManagedObjectContext) throws -> [Self] {
    guard let request = fetchRequest() as? NSFetchRequest<Self> else {
      preconditionFailure("Invalid fetch request for \(Self.self)")
    }
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    return try context.fetch(request)
  }
  
  static func findAll(matching predicate: NSPredicate?, sortedBy sortDescriptors: [NSSortDescriptor]? = nil, in context: NSManagedObjectContext) throws -> [Self] {
    guard let request = fetchRequest() as? NSFetchRequest<Self> else {
      preconditionFailure("Invalid fetch request for \(Self.self)")
    }
    request.predicate = predicate
    request.sortDescriptors = sortDescriptors
    
    return try context.fetch(request)
  }
  
  static func find(byID id: Int64, in context: NSManagedObjectContext) throws -> Self? {
    guard let request = fetchRequest() as? NSFetchRequest<Self> else {
      preconditionFailure("Invalid fetch request for \(Self.self)")
    }
    request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
    request.fetchLimit = 1
    
    return try context.fetch(request).first
  }
  
  static func find(byIDs ids: [Int64], in context: NSManagedObjectContext) throws -> [Self] {
    guard !ids.isEmpty else {
      return []
    }
    
    guard let request = fetchRequest() as? NSFetchRequest<Self> else {
      preconditionFailure("Invalid fetch request for \(Self.self)")
    }
    request.predicate = NSPredicate(format: "id IN %@", ids)
    
    return try context.fetch(request)
  }
  
  static func find(byPredicate predicate: NSPredicate, in context: NSManagedObjectContext) throws -> Self? {
    guard let request = fetchRequest() as? NSFetchRequest<Self> else {
      preconditionFailure("Invalid fetch request for \(Self.self)")
    }
    request.predicate = predicate
    request.fetchLimit = 1
    
    return try context.fetch(request).first
  }
  
}
