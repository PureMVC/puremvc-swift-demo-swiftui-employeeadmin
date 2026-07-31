//
//  DepartmentData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

final class DepartmentStore: IDepartmentStore {
  
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func findAll() throws -> [Department] {
    try context.performAndWait {
      try DepartmentManagedObject
        .findAll(in: context)
        .map { $0.toDepartment() }
    }
  }
  
  func findAll(byIDs ids: [Int64]) throws -> [Department] {
    try context.performAndWait {
      try DepartmentManagedObject
        .findAll(matching: NSPredicate(format: "id IN %@", ids), in: context)
        .map { $0.toDepartment() }
    }
  }

  func find(byID id: Int64) throws -> Department? {
    try context.performAndWait {
      try DepartmentManagedObject
        .find(byID: id, in: context)?
        .toDepartment()
    }
  }
  
  func save(_ department: Department) throws {
    try context.performAndWait {
      let object = factory()
      update(object, from: department)
      
      if context.hasChanges {
        try context.save()
      }
    }
  }
  
  func saveAll(_ departments: [Department]) throws {
    try context.performAndWait {
      departments.forEach { deparment in
        let object = factory()
        update(object, from: deparment)
      }
      
      if context.hasChanges {
        try context.save()
      }
    }
  }
  
}

extension DepartmentStore {
  
  func factory() -> DepartmentManagedObject {
    guard let entity = NSEntityDescription.entity(forEntityName: "DepartmentManagedObject", in: context) else {
      preconditionFailure("DepartmentManagedObject entity not found")
    }
    
    return DepartmentManagedObject(entity: entity, insertInto: context)
  }
  
  func update(_ object: DepartmentManagedObject, from department: Department) {
    object.id = department.id
    object.name = department.name
  }
  
}
