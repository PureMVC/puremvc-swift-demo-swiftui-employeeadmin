//
//  UserData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

final class UserStore: IUserStore {
  
  private let context: NSManagedObjectContext
  private let departmentStore: DepartmentStore
  private let roleStore: RoleStore
  
  init(departmentStore: DepartmentStore, roleStore: RoleStore, context: NSManagedObjectContext) {
    self.context = context
    self.departmentStore = departmentStore
    self.roleStore = roleStore
  }
  
  func findAll() throws -> [User] {
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    return try context.fetch(request).toDomain()
  }
  
  func findAll(byIDs ids: Set<Int64>) throws -> [User] {
    try findAllManagedObjects(byIDs: ids).toDomain()
  }
  
  func find(byID id: Int64) throws -> User? {
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    request.predicate = NSPredicate(format: "id == %d", id)
    
    return try context.fetch(request).first?.toDomain()
  }
  
  private func upsert(_ user: User) throws -> User {
    let object: UserManagedObject
    
    if user.id == 0 {
      object = user.toManagedObject(in: context)
      object.id = try nextID()
    } else {
      guard let existing = try findManagedObject(byID: user.id) else {
        throw Error.userNotFound(user.id)
      }
      
      object = existing
    }
    
    user.update(object)
        
    guard let department = try departmentStore.findManagedObject(byID: user.department.id) else {
      throw Error.departmentNotFound(user.department.id)
    }
    object.department = department
    
    let roleIDs = Set(user.roles.map(\.id))
    let roles = try roleStore.findAllManagedObjects(byIDs: roleIDs)
    
    let missingIDs = roleIDs.subtracting(roles.map(\.id))
    guard missingIDs.isEmpty else {
      throw Error.rolesNotFound(missingIDs)
    }
    
    object.roles = NSSet(set: roles)
    
    return object.toDomain()
  }
  
  @discardableResult
  func save(_ user: User) throws -> User {
    let saved = try upsert(user)
    
    if context.hasChanges {
      try context.save()
    }
    
    return saved
  }
  
  @discardableResult
  func saveAll(_ users: [User]) throws -> [User] {
    var saved: [User] = []
    
    for user in users {
      saved.append(try upsert(user))
    }
    
    if context.hasChanges {
      try context.save()
    }
    
    return saved
  }
  
  func delete(_ user: User) throws {
    try delete(byID: user.id)
  }
  
  func delete(byID id: Int64) throws {
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    request.predicate = NSPredicate(format: "id == %d", id)
    request.fetchLimit = 1
    
    if let object = try context.fetch(request).first {
      context.delete(object)
    }
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func deleteAll() throws {
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<any NSFetchRequestResult>)
    try context.execute(deleteRequest)
    
    try context.save()
  }
  
  func deleteAll(_ users: [User]) throws {
    let ids = Set(users.map(\.id))
    try deleteAll(byIDs: ids)
  }
  
  func deleteAll(byIDs ids: Set<Int64>) throws {
    guard !ids.isEmpty else {
      return
    }
    
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    request.predicate = NSPredicate(format: "id IN %@", ids)
    
    let objects = try context.fetch(request)
    objects.forEach { context.delete($0) }
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func count() throws -> Int {
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    return try context.count(for: request)
  }
  
}

private extension UserStore {
    
  private func nextID() throws -> Int64 {
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
    request.fetchLimit = 1
    
    if let user = try context.fetch(request).first {
      return user.id + 1
    }
    
    return 1
  }
  
}

extension UserStore {
  
  func findManagedObject(byID id: Int64) throws -> UserManagedObject? {
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    request.predicate = NSPredicate(format: "id == %d", id)
    request.fetchLimit = 1
    
    return try context.fetch(request).first
  }
  
  func findAllManagedObjects(byIDs ids: Set<Int64>) throws -> [UserManagedObject] {
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    request.predicate = NSPredicate(format: "id IN %@", ids)
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    return try context.fetch(request)
  }
  
}

extension UserStore {
  enum Error: Swift.Error {
    case userNotFound(Int64)
    case departmentNotFound(Int64)
    case rolesNotFound(Set<Int64>)
  }
}
