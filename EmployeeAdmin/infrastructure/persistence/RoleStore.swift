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
    try context.performAndWait {
      try RoleManagedObject
        .findAll(in: context)
        .map { $0.toRole() }
    }
  }
  
  func findAll(byIDs ids: [Int64]) throws -> [Role] {
    try context.performAndWait {
      try RoleManagedObject
        .findAll(matching: NSPredicate(format: "id IN %@", ids), in: context)
        .map { $0.toRole() }
    }
  }
  
  func find(byID id: Int64) throws -> Role? {
    try context.performAndWait {
      try RoleManagedObject
        .find(byID: id, in: context)?
        .toRole()
    }
  }
 
  func find(byUserID id: Int64) throws -> [Role] {
    try context.performAndWait {
      try RoleManagedObject
        .findAll(matching: NSPredicate(format: "ANY users.id = %d", id), in: context)
        .map { $0.toRole() }
    }
  }
  
  func save(_ role: Role) throws {
    try context.performAndWait {
      do {
        let object = factory()
        update(object, from: role)
        
        if context.hasChanges {
          try context.save()
        }
      } catch {
        context.rollback()
        throw error
      }
    }
  }
  
  func saveAll(_ roles: [Role]) throws {
    try context.performAndWait {
      roles.forEach { role in
        let object = factory()
        update(object, from: role)
      }
      
      if context.hasChanges {
        try context.save()
      }
    }
  }
  
  func count() throws -> Int {
    try context.performAndWait {
      try RoleManagedObject.count(in: context)
    }
  }
  
}

extension RoleStore {
  
  func factory() -> RoleManagedObject {
    guard let entity = NSEntityDescription.entity(forEntityName: "RoleManagedObject", in: context) else {
      preconditionFailure("RoleManagedObject entity not found")
    }
    
    return RoleManagedObject(entity: entity, insertInto: context)
  }
  
  func update(_ object: RoleManagedObject, from role: Role) {
    object.id = role.id
    object.name = role.name
  }

}
