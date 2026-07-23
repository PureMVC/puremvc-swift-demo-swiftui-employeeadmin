//
//  RoleRealmObject.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import RealmSwift

final class RoleRealmObject: Object, ObjectKeyIdentifiable {
  
  @Persisted(primaryKey: true) var id: Int64
  @Persisted var name: String
  
  convenience init(id: Int64, name: String) {
    self.init()
    
    self.id = id
    self.name = name
  }
  
}

extension RoleRealmObject {
  
  func toDomain() -> Role {
    Role(id: id, name: name)
  }
  
}

extension Role {
  
  func toRealmObject() -> RoleRealmObject {
    RoleRealmObject(id: id, name: name)
  }
  
}

extension List where Element == RoleRealmObject {
  
  func toDomain() -> [Role] {
    map { $0.toDomain() }
  }
  
}

extension Results where Element == RoleRealmObject {
  
  func toDomain() -> [Role] {
    map { $0.toDomain() }
  }
  
}

extension Sequence where Element == Role {
 
  func toRealmObjects() -> List<RoleRealmObject> {
    let list = List<RoleRealmObject>()
    list.append(objectsIn: map { $0.toRealmObject() })
    return list
  }
  
}
