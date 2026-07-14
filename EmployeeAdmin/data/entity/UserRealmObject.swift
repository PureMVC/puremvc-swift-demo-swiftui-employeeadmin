//
//  UserRealmObject.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import RealmSwift

final class UserRealmObject: Object, ObjectKeyIdentifiable {
  
  @Persisted(primaryKey: true) var id: Int64
  @Persisted var first: String
  @Persisted var last: String
  @Persisted var email: String
  @Persisted var username: String
  @Persisted var password: String
  @Persisted var department: DepartmentRealmObject?
  @Persisted var roles: List<RoleRealmObject> = List<RoleRealmObject>()

  convenience init(id: Int64, first: String, last: String, email: String, username: String, department: DepartmentRealmObject, roles: List<RoleRealmObject> = List<RoleRealmObject>()) {
    self.init()
    
    self.id = id
    self.first = first
    self.last = last
    self.email = email
    self.username = username
    self.department = department
    self.roles.append(objectsIn: roles)
  }

}

extension UserRealmObject {
  
  func toDomain() -> User {
    User(id: id, first: first, last: last, email: email, username: username, password: password, department: department?.toDomain() ?? .none, roles: roles.toDomain())
  }
    
}

extension User {
  
  func toRealmObject() -> UserRealmObject {
    let object = UserRealmObject()
    
    object.id = id
    object.first = first
    object.last = last
    object.email = email
    object.username = username
    object.password = password
    object.department = department.toRealmObject()
    if let roles = roles {
      object.roles.removeAll()
      object.roles.append(objectsIn: roles.toRealmObjects())
    }
    
    return object
  }
  
  func update(_ object: UserRealmObject) {
    object.first = first
    object.last = last
    object.email = email
    object.username = username
    object.password = password
  }
  
}

extension Sequence where Element == UserRealmObject {
  
  func toDomain() -> [User] {
    map { $0.toDomain() }
  }
  
}
