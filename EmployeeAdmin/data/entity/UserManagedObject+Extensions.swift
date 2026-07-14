//
//  UserManagedObject+Extensions.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation
import CoreData

extension UserManagedObject {
  
  func toDomain() -> User {
    User(id: id, first: first, last: last, email: email, username: username, password: password,
      department: department?.toDomain() ?? .none,
      roles: Set((roles as? Set<RoleManagedObject>)?.map { $0.toDomain() } ?? []))
  }
  
}

extension User {
  
  func toManagedObject(in context: NSManagedObjectContext) -> UserManagedObject {
    guard let entity = NSEntityDescription.entity(forEntityName: "UserManagedObject", in: context) else {
      preconditionFailure("UserManagedObject entity not found")
    }
    
    let object = UserManagedObject(entity: entity, insertInto: context)
    update(object)
    
    return object
  }
  
  func update(_ object: UserManagedObject) {
    object.first = first
    object.last = last
    object.email = email
    object.username = username
    object.password = password
  }
  
}

extension Sequence where Element == UserManagedObject {
  
  func toDomain() -> [User] {
    map { $0.toDomain() }
  }
  
}

extension Sequence where Element == User {
  
  func toManagedObjects(in context: NSManagedObjectContext) -> [UserManagedObject] {
    map { $0.toManagedObject(in: context) }
  }
  
}

