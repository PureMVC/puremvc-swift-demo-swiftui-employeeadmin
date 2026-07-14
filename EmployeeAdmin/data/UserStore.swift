//
//  UserData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import RealmSwift

final class UserStore: IUserStore {
  
  enum Error: Swift.Error {
    case userNotFound(Int64)
    case departmentNotFound(Int64)
    case rolesNotFound([Int64])
    case saveFailed
  }
  
  private let configuration: Realm.Configuration
  private let departmentStore: DepartmentStore
  private let roleStore: RoleStore
  
  init(departmentStore: DepartmentStore, roleStore: RoleStore, configuration: Realm.Configuration) {
    self.configuration = configuration
    self.departmentStore = departmentStore
    self.roleStore = roleStore
  }
  
  func findAll() throws -> [User] {
    let realm = try Realm(configuration: configuration)
    let users = realm.objects(UserRealmObject.self).sorted(byKeyPath: "id", ascending: true)
    
    return users.toDomain()
  }
  
  func findAll(byIDs ids: [Int64]) throws -> [User] {
    let realm = try Realm(configuration: configuration)
    let users = realm.objects(UserRealmObject.self).where { $0.id.in(ids) }
    
    return users.toDomain()
  }
  
  func find(byID id: Int64) throws -> User? {
    let realm = try Realm(configuration: configuration)
    let user = realm.object(ofType: UserRealmObject.self, forPrimaryKey: id)
    
    return user?.toDomain()
  }
  
  private func upsert(_ user: User, in realm: Realm) throws -> User {
    let object: UserRealmObject
    
    if user.id == 0 {
      object = user.toRealmObject()
      object.id = try nextID(in: realm)
    } else {
      guard let existing = realm.object(ofType: UserRealmObject.self, forPrimaryKey: user.id) else {
        throw Error.userNotFound(user.id)
      }
      
      object = existing
    }
    
    user.update(object)
        
    guard let department = realm.object(ofType: DepartmentRealmObject.self, forPrimaryKey: user.department.id) else {
      throw Error.departmentNotFound(user.department.id)
    }
    object.department = department
    
    let roleIDs = user.roles.map(\.id)
    let roles = realm.objects(RoleRealmObject.self).where { $0.id.in(roleIDs) }
    
    let foundRoleIDs = roles.map(\.id)
    let missingIDs = roleIDs.filter { !foundRoleIDs.contains($0) }
    
    guard missingIDs.isEmpty else {
      throw Error.rolesNotFound(missingIDs)
    }
    
    object.roles.removeAll()
    object.roles.append(objectsIn: roles)
    
    realm.add(object, update: .modified)
    
    return object.toDomain()
  }
  
  @discardableResult
  func save(_ user: User) throws -> User {
    let realm = try Realm(configuration: configuration)
    var saved: User?
    
    try realm.write {
      saved = try upsert(user, in: realm)
    }
    
    guard let saved else {
      throw Error.saveFailed
    }
    
    return saved
  }
  
  @discardableResult
  func saveAll(_ users: [User]) throws -> [User] {
    let realm = try Realm(configuration: configuration)
    var saved: [User] = []
    
    try realm.write {
      saved = try users.map { try upsert($0, in: realm) }
    }
    
    return saved
  }
  
  func delete(_ user: User) throws {
    try delete(byID: user.id)
  }
  
  func delete(byID id: Int64) throws {
    let realm = try Realm(configuration: configuration)
    
    guard let user = realm.object(ofType: UserRealmObject.self, forPrimaryKey: id) else {
      return
    }
    
    try realm.write {
      realm.delete(user)
    }
  }
  
  func deleteAll() throws {
    let realm = try Realm(configuration: configuration)
    
    try realm.write {
      realm.delete(realm.objects(UserRealmObject.self))
    }
  }
  
  func deleteAll(_ users: [User]) throws {
    let ids = users.map(\.id)
    try deleteAll(byIDs: ids)
  }
  
  func deleteAll(byIDs ids: [Int64]) throws {
    let realm = try Realm(configuration: configuration)
    
    let objects = realm.objects(UserRealmObject.self).where { $0.id.in(ids) }
    
    try realm.write {
      realm.delete(objects)
    }
  }
  
  func count() throws -> Int {
    let realm = try Realm(configuration: configuration)
    return realm.objects(UserRealmObject.self).count
  }
  
}

private extension UserStore {
    
  private func nextID(in realm: Realm) throws -> Int64 {
    let id = realm.objects(UserRealmObject.self).max(ofProperty: "id") as Int64?
    
    return (id ?? 0) + 1
  }
  
}

extension UserStore {
  
  func findRealmObject(byID id: Int64) throws -> UserRealmObject? {
    let realm = try Realm(configuration: configuration)
    
    return realm.object(ofType: UserRealmObject.self, forPrimaryKey: id)
  }
  
  func findAllRealmObjects(byIDs ids: [Int64]) throws -> [UserRealmObject] {
    let realm = try Realm(configuration: configuration)
    
    let users = realm.objects(UserRealmObject.self)
      .where { $0.id.in(ids) }
      .sorted(byKeyPath: "id", ascending: true)
    
    return Array(users)
  }
  
}
