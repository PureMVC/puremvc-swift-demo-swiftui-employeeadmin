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
    try DepartmentManagedObject
      .findAll(in: context)
      .toDomain()
  }
  
  func findAll(byIDs ids: [Int64]) throws -> [Department] {
    try DepartmentManagedObject
      .findAll(matching: NSPredicate(format: "id IN %@", ids), in: context)
      .toDomain()
  }

  func find(byID id: Int64) throws -> Department? {
    try DepartmentManagedObject
      .find(byID: id, in: context)?
      .toDomain()
  }
  
  func save(_ department: Department) throws {
    _ = toManagedObject(from: department)
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func saveAll(_ departments: [Department]) throws {
    _ = toManagedObjects(from: departments)
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func count() throws -> Int {
    try DepartmentManagedObject.count(in: context)
  }
  
}

extension DepartmentStore {
  
  func toManagedObject(from department: Department) -> DepartmentManagedObject {
    guard let entity = NSEntityDescription.entity(forEntityName: "DepartmentManagedObject", in: context) else {
      preconditionFailure("DepartmentManagedObject entity not found")
    }
    
    let object = DepartmentManagedObject(entity: entity, insertInto: context)
    update(object, from: department)
    
    return object
  }
  
  func toManagedObjects(from departments: [Department]) -> [DepartmentManagedObject] {
    departments.map { toManagedObject(from: $0) }
  }
  
  func update(_ object: DepartmentManagedObject, from department: Department) {
    object.id = department.id
    object.name = department.name
  }
  
}
