//
//  UserData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

final class UserStore: IUserStore {
  
  enum Error: Swift.Error {
    case userNotFound(Int64)
    case departmentNotFound(Int64)
    case rolesNotFound([Int64])
  }
  
  private let context: NSManagedObjectContext
  private let departmentStore: DepartmentStore
  private let roleStore: RoleStore
  
  init(departmentStore: DepartmentStore, roleStore: RoleStore, context: NSManagedObjectContext) {
    self.context = context
    self.departmentStore = departmentStore
    self.roleStore = roleStore
  }
  
  func findAll() throws -> [User] {
    try UserManagedObject
      .findAll(in: context)
      .toDomain()
  }
  
  func findAll(byIDs ids: [Int64]) throws -> [User] {
    try UserManagedObject
      .findAll(matching: NSPredicate(format: "id IN %@", ids), in: context)
      .toDomain()
  }
  
  func find(byID id: Int64) throws -> User? {
    try UserManagedObject
      .find(byID: id, in: context)?
      .toDomain()
  }
  
  @discardableResult
  func save(_ user: User) throws -> User {
    let saved = try upsert(user)
    
    if context.hasChanges {
      try context.save()
    }
    
    return saved.toDomain()
  }
  
  @discardableResult
  func saveAll(_ users: [User]) throws -> [User] {
    var saved: [UserManagedObject] = []
    
    do {
      saved = try users.map { try upsert($0) }
      try context.save()
    } catch {
      context.rollback()
      throw error
    }
    
    if context.hasChanges {
      try context.save()
    }
    
    return saved.toDomain()
  }
  
  func delete(_ user: User) throws {
    try delete(byID: user.id)
  }
  
  func delete(byID id: Int64) throws {
    guard let object = try UserManagedObject.find(byID: id, in: context) else {
      return
    }
    
    context.delete(object)
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func deleteAll() throws {
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    
    // Deletes directly from persistent store, bypassing the managed object context
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
    
    // Return deleted object IDs so the context can be updated
    deleteRequest.resultType = .resultTypeObjectIDs
    
    let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
    
    if let objectIDs = result?.result as? [NSManagedObjectID] {
      // Notify context about deleted objects to avoid stale in-memory objects
      let changes = [NSDeletedObjectsKey: objectIDs]
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
    }
  }
  
  func deleteAll(_ users: [User]) throws {
    try deleteAll(byIDs: users.map(\.id))
  }
  
  func deleteAll(byIDs ids: [Int64]) throws {
    guard !ids.isEmpty else {
      return
    }
    
    let objects = try UserManagedObject.findAll(matching: NSPredicate(format: "id IN %@", ids), sortedBy: [NSSortDescriptor(key: "id", ascending: true)], in: context)
        
    objects.forEach { context.delete($0) }
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func count() throws -> Int {
    try UserManagedObject.count(in: context)
  }
  
}

private extension UserStore {
  
  func toManagedObject(from user: User) -> UserManagedObject {
    guard let entity = NSEntityDescription.entity(forEntityName: "UserManagedObject", in: context) else {
      preconditionFailure("UserManagedObject entity not found")
    }
    
    let object = UserManagedObject(entity: entity, insertInto: context)
    update(object, from: user)
    
    return object
  }
  
  func toManagedObjects(from users: [User]) -> [UserManagedObject] {
    users.map { toManagedObject(from: $0) }
  }
  
  func update(_ object: UserManagedObject, from user: User) {
    object.first = user.first
    object.last = user.last
    object.email = user.email
    object.username = user.username
    object.password = user.password
  }
  
  func upsert(_ user: User) throws -> UserManagedObject {
    let object: UserManagedObject
    
    if user.id == 0 {
      object = toManagedObject(from: user)
      
      object.id = try nextID()
    } else {
      guard let existing = try UserManagedObject.find(byID: user.id, in: context) else {
        throw Error.userNotFound(user.id)
      }
      
      object = existing
    }
    
    update(object, from: user)
    
    guard let department = try DepartmentManagedObject.find(byID: user.department.id, in: context) ?? .none else {
      throw Error.departmentNotFound(user.department.id)
    }
    object.department = department
    
    if let roles = user.roles {
      let roleIDs = roles.map(\.id)
      let roles = try RoleManagedObject.findAll(matching: NSPredicate(format: "id IN %@", roleIDs), in: context)
      
      let foundRoleIDs = roles.map(\.id)
      let missingIDs = roleIDs.filter { !foundRoleIDs.contains($0) }
      
      guard missingIDs.isEmpty else {
        throw Error.rolesNotFound(missingIDs)
      }
      
      object.roles = NSSet(array: roles)
    }
    
    return object
  }
    
  func nextID() throws -> Int64 {
    let request: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
    request.fetchLimit = 1
    
    return try context.fetch(request).first.map { $0.id + 1 } ?? 1
  }
  
}
