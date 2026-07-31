//
//  UserManagedObject+Mapping.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

extension UserManagedObject: ActiveRecord {
  
}

extension UserManagedObject {
  
  func toUser() -> User {
    User(
      id: id,
      first: first ?? "",
      last: last ?? "",
      email: email ?? "",
      username: username ?? "",
      password: password ?? "",
      department: department?.toDepartment() ?? .none,
      roles: roles?.compactMap { ($0 as? RoleManagedObject)?.toRole() }
    )
  }
  
}
