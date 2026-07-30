//
//  RoleManagedObject+Mapping.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

extension RoleManagedObject: ActiveRecord {
  
}

extension RoleManagedObject {

  func toRole() -> Role {
    Role(id: id, name: name ?? "")
  }
  
}
