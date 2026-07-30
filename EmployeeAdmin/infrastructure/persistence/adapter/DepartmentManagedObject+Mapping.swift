//
//  DepartmentManagedObject+Mapping.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

extension DepartmentManagedObject: ActiveRecord {
  
}

extension DepartmentManagedObject {

  func toDepartment() -> Department {
    Department(id: id, name: name ?? "")
  }
  
}

extension Sequence where Element == DepartmentManagedObject {
  
  func toDepartment() -> [Department] {
    map { $0.toDepartment() }
  }
  
}
