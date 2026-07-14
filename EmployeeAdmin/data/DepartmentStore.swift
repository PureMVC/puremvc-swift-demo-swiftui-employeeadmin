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
  
  func findAll() throws -> Set<Department> {
    let request: NSFetchRequest<DepartmentManagedObject> = DepartmentManagedObject.fetchRequest()
    
    return Set(try context.fetch(request).toDomain())
  }
  
  func findAll(byIDs ids: Set<Int64>) throws -> Set<Department> {
    Set(try findAllManagedObjects(byIDs: ids).toDomain())
  }

  func find(byID id: Int64) throws -> Department? {
    try findManagedObject(byID: id)?.toDomain()
  }
  
  func save(_ department: Department) throws {
    _ = department.toManagedObject(in: context)
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func saveAll(_ departments: Set<Department>) throws {
    _ = departments.toManagedObjects(in: context)
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func count() throws -> Int {
    let request: NSFetchRequest<DepartmentManagedObject> = DepartmentManagedObject.fetchRequest()
    return try context.count(for: request)
  }
  
}

extension DepartmentStore {
  
  func findManagedObject(byID id: Int64) throws -> DepartmentManagedObject? {
    let request: NSFetchRequest<DepartmentManagedObject> = DepartmentManagedObject.fetchRequest()
    request.predicate = NSPredicate(format: "id == %d", id)
    request.fetchLimit = 1
    
    return try context.fetch(request).first
  }
  
  func findAllManagedObjects(byIDs ids: Set<Int64>) throws -> Set<DepartmentManagedObject> {
    let request: NSFetchRequest<DepartmentManagedObject> = DepartmentManagedObject.fetchRequest()
    request.predicate = NSPredicate(format: "id IN %@", ids)
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    return Set(try context.fetch(request))
  }
  
}
