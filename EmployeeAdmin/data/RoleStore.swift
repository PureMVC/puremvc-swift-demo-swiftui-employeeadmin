//
//  RoleData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

final class RoleStore: IRoleStore {
  
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func findAll() throws -> [Role] {
    let request: NSFetchRequest<RoleManagedObject> = RoleManagedObject.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    return try context.fetch(request).toDomain()
  }
  
  func findAll(byIDs ids: [Int64]) throws -> [Role] {
    try findAllManagedObjects(byIDs: ids).toDomain()
  }
  
  func find(byID id: Int64) throws -> Role? {
    try findManagedObject(byID: id)?.toDomain()
  }
 
  func find(byUserID id: Int64) throws -> [Role] {
    let request: NSFetchRequest<RoleManagedObject> = RoleManagedObject.fetchRequest()
    request.predicate = NSPredicate(format: "ANY users.id = %d", id)
    
    return try context.fetch(request).toDomain()
  }
  
  func save(_ role: Role) throws {
    _ = role.toManagedObject(in: context)
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func saveAll(_ roles: [Role]) throws {
    _ = roles.toManagedObjects(in: context)
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func count() throws -> Int {
    let request: NSFetchRequest<RoleManagedObject> = RoleManagedObject.fetchRequest()
    return try context.count(for: request)
  }
  
}

extension RoleStore {
  
  func findManagedObject(byID id: Int64) throws -> RoleManagedObject? {
    let request: NSFetchRequest<RoleManagedObject> = RoleManagedObject.fetchRequest()
    request.predicate = NSPredicate(format: "id == %d", id)
    request.fetchLimit = 1
    
    return try context.fetch(request).first
  }
  
  func findAllManagedObjects(byIDs ids: [Int64]) throws -> [RoleManagedObject] {
    let request: NSFetchRequest<RoleManagedObject> = RoleManagedObject.fetchRequest()
    request.predicate = NSPredicate(format: "id IN %@", ids)
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    return try context.fetch(request)
  }
  
}
