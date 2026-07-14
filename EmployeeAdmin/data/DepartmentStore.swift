//
//  DepartmentData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import RealmSwift

final class DepartmentStore: IDepartmentStore {
  
  private let configuration: Realm.Configuration
  
  init(configuration: Realm.Configuration) {
    self.configuration = configuration
  }
  
  func findAll() throws -> [Department] {
    let realm = try Realm(configuration: configuration)
    let departments = realm.objects(DepartmentRealmObject.self).sorted(byKeyPath: "id", ascending: true)
    
    return departments.toDomain()
  }
  
  func findAll(byIDs ids: [Int64]) throws -> [Department] {
    let realm = try Realm(configuration: configuration)
    let departments = realm.objects(DepartmentRealmObject.self).where { $0.id.in(ids) }
    
    return departments.toDomain()
  }

  func find(byID id: Int64) throws -> Department? {
    let realm = try Realm(configuration: configuration)
    let department = realm.object(ofType: DepartmentRealmObject.self, forPrimaryKey: id)
    
    return department?.toDomain()
  }
  
  func save(_ department: Department) throws {
    let realm = try Realm(configuration: configuration)
    
    try realm.write {
      realm.add(department.toRealmObject(), update: .modified)
    }
  }
  
  func saveAll(_ departments: [Department]) throws {
    let realm = try Realm(configuration: configuration)
    
    try realm.write {
      realm.add(departments.toRealmObjects(), update: .modified)
    }
  }
  
  func count() throws -> Int {
    let realm = try Realm(configuration: configuration)
    return realm.objects(DepartmentRealmObject.self).count
  }
  
}

extension DepartmentStore {
  
  func findRealmObject(byID id: Int64) throws -> DepartmentRealmObject? {
    let realm = try Realm(configuration: configuration)
    
    return realm.object(ofType: DepartmentRealmObject.self, forPrimaryKey: id)
  }
  
  func findAllRealmObjects(byIDs ids: [Int64]) throws -> [DepartmentRealmObject] {
    let realm = try Realm(configuration: configuration)
    
    let departments = realm.objects(DepartmentRealmObject.self)
      .where { $0.id.in(ids) }
      .sorted(byKeyPath: "id", ascending: true)
    
    return Array(departments)
  }
  
}
