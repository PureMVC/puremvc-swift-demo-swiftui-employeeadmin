//
//  RoleData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import RealmSwift

final class RoleStore: IRoleStore {
  
  private let configuration: Realm.Configuration
  
  init(configuration: Realm.Configuration) {
    self.configuration = configuration
  }
  
  func findAll() throws -> [Role] {
    let realm = try Realm(configuration: configuration)
    let roles = realm.objects(RoleRealmObject.self).sorted(byKeyPath: "id", ascending: true)
    
    return roles.toDomain()
  }
  
  func findAll(byIDs ids: [Int64]) throws -> [Role] {
    let realm = try Realm(configuration: configuration)
    let roles = realm.objects(RoleRealmObject.self).where { $0.id.in(ids) }
    
    return roles.toDomain()
  }
  
  func find(byID id: Int64) throws -> Role? {
    let realm = try Realm(configuration: configuration)
    let role = realm.object(ofType: RoleRealmObject.self, forPrimaryKey: id)
    
    return role?.toDomain()
  }
 
  func find(byUserID id: Int64) throws -> [Role] {
    let realm = try Realm(configuration: configuration)
    
    guard let user = realm.object(ofType: UserRealmObject.self, forPrimaryKey: id) else {
      return []
    }
    
    return user.roles.toDomain()
  }
  
  func save(_ role: Role) throws {
    let realm = try Realm(configuration: configuration)
    
    try realm.write {
      realm.add(role.toRealmObject(), update: .modified)
    }
  }
  
  func saveAll(_ roles: [Role]) throws {
    let realm = try Realm(configuration: configuration)
    
    try realm.write {
      realm.add(roles.toRealmObjects(), update: .modified)
    }
  }
  
  func count() throws -> Int {
    let realm = try Realm(configuration: configuration)
    return realm.objects(RoleRealmObject.self).count
  }
  
}

extension RoleStore {
  
  func findRealmObject(byID id: Int64) throws -> RoleRealmObject? {
    let realm = try Realm(configuration: configuration)
    
    return realm.object(ofType: RoleRealmObject.self, forPrimaryKey: id)
  }
  
  func findAllRealmObjects(byIDs ids: [Int64]) throws -> [RoleRealmObject] {
    let realm = try Realm(configuration: configuration)
    
    let roles = realm.objects(RoleRealmObject.self)
      .where { $0.id.in(ids) }
      .sorted(byKeyPath: "id", ascending: true)
    
    return Array(roles)
  }
  
}
