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
    try RoleManagedObject
      .findAll(in: context)
      .toDomain()
  }
  
  func findAll(byIDs ids: [Int64]) throws -> [Role] {
    try RoleManagedObject
      .findAll(matching: NSPredicate(format: "id IN %@", ids), in: context)
      .toDomain()
  }
  
  func find(byID id: Int64) throws -> Role? {
    try RoleManagedObject
      .find(byID: id, in: context)?
      .toDomain()
  }
 
  func find(byUserID id: Int64) throws -> [Role] {
    try RoleManagedObject
      .findAll(matching: NSPredicate(format: "ANY users.id = %d", id), in: context)
      .toDomain()
  }
  
  func save(_ role: Role) throws {
    _ = toManagedObject(from: role)
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func saveAll(_ roles: [Role]) throws {
    _ = toManagedObjects(from: roles)
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func count() throws -> Int {
    try RoleManagedObject.count(in: context)
  }
  
}

extension RoleStore {
  
  func toManagedObject(from role: Role) -> RoleManagedObject {
    guard let entity = NSEntityDescription.entity(forEntityName: "RoleManagedObject", in: context) else {
      preconditionFailure("RoleManagedObject entity not found")
    }
    
    let object = RoleManagedObject(entity: entity, insertInto: context)
    update(object, from: role)
    
    return object
  }
  
  func toManagedObjects(from roles: [Role]) -> [RoleManagedObject] {
    roles.map { toManagedObject(from: $0) }
  }
  
  func update(_ object: RoleManagedObject, from role: Role) {
    object.id = role.id
    object.name = role.name
  }

}
