//
//  RoleManagedObject+Extensions.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation
import CoreData

extension RoleManagedObject {

  func toDomain() -> Role {
    Role(id: id, name: name)
  }
  
}

extension Role {
  
  func toManagedObject(in context: NSManagedObjectContext) -> RoleManagedObject {
    guard let entity = NSEntityDescription.entity(forEntityName: "RoleManagedObject", in: context) else {
      preconditionFailure("RoleManagedObject entity not found")
    }
    
    let object = RoleManagedObject(entity: entity, insertInto: context)
    update(object)
    
    return object
  }
  
  func update(_ object: RoleManagedObject) {
    object.id = id
    object.name = name
  }
  
}

extension Sequence where Element == RoleManagedObject {
  
  func toDomain() -> [Role] {
    map { $0.toDomain() }
  }
  
}

extension Sequence where Element == Role {
  
  func toManagedObjects(in context: NSManagedObjectContext) -> [RoleManagedObject] {
    map { $0.toManagedObject(in: context) }
  }
  
}
