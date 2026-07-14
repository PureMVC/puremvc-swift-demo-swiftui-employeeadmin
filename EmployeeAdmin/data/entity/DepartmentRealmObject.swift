//
//  DepartmentRealmObject.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import RealmSwift

final class DepartmentRealmObject: Object, ObjectKeyIdentifiable {
  
  @Persisted(primaryKey: true) var id: Int64
  @Persisted var name: String
  
  convenience init(id: Int64, name: String) {
    self.init()
    
    self.id = id
    self.name = name
  }
  
}

extension DepartmentRealmObject {
  
  func toDomain() -> Department {
    Department(id: id, name: name)
  }
  
}

extension Department {
  
  func toRealmObject() -> DepartmentRealmObject {
    DepartmentRealmObject(id: id, name: name)
  }
  
}

extension List where Element == DepartmentRealmObject {
  
  func toDomain() -> [Department] {
    map { $0.toDomain() }
  }
  
}

extension Results where Element == DepartmentRealmObject {
  
  func toDomain() -> [Department] {
    map { $0.toDomain() }
  }
  
}

extension Sequence where Element == Department {
  
  func toRealmObjects() -> List<DepartmentRealmObject> {
    let list = List<DepartmentRealmObject>()
    list.append(objectsIn: map { $0.toRealmObject() })
    return list
  }
  
}
