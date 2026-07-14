//
//  DepartmentManagedObject+Extensions.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation
import CoreData

extension DepartmentManagedObject {

  func toDomain() -> Department {
    Department(id: id, name: name)
  }
  
}

extension Department {
  
  func toManagedObject(in context: NSManagedObjectContext) -> DepartmentManagedObject {
    guard let entity = NSEntityDescription.entity(forEntityName: "DepartmentManagedObject", in: context) else {
      preconditionFailure("DepartmentManagedObject entity not found")
    }
    
    let object = DepartmentManagedObject(entity: entity, insertInto: context)
    update(object)
    
    return object
  }
  
  func update(_ object: DepartmentManagedObject) {
    object.id = id
    object.name = name
  }
  
}

extension Sequence where Element == DepartmentManagedObject {
  
  func toDomain() -> [Department] {
    map { $0.toDomain() }
  }
  
}

extension Sequence where Element == Department {
  
  func toManagedObjects(in context: NSManagedObjectContext) -> [DepartmentManagedObject] {
    map { $0.toManagedObject(in: context) }
  }
  
}
