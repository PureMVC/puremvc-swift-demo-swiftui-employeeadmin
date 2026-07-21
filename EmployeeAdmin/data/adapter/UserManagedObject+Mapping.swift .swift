//
//  UserManagedObject+Mapping.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation

extension UserManagedObject: ActiveRecord {
  
}

extension UserManagedObject {
  
  func toDomain() -> User {
    User(
      id: id,
      first: first ?? "",
      last: last ?? "",
      email: email ?? "",
      username: username ?? "",
      password: password ?? "",
      department: department?.toDomain() ?? .none,
      roles: roles?.toDomain()
    )
  }
  
}

extension Sequence where Element == UserManagedObject {

  func toDomain() -> [User] {
    map { $0.toDomain() }
  }

}
