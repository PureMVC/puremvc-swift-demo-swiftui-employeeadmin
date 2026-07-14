//
//  UserDataTest.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Testing
@testable import EmployeeAdmin
import RealmSwift

@MainActor
struct UserStoreTest {
  
  private let configuration: Realm.Configuration
  private let departmentStore: DepartmentStore
  private let roleStore: RoleStore
  private var sut: UserStore!
  
  init() throws {
    configuration = try ApplicationPersistence(inMemory: true).configuration
    departmentStore = DepartmentStore(configuration: configuration)
    roleStore = RoleStore(configuration: configuration)
    sut = UserStore(departmentStore: departmentStore, roleStore: roleStore, configuration: configuration)
  }

  @Test func testFindAll() throws {
    let accounting = Department(id: 1, name: "Accounting")
    let sales = Department(id: 2, name: "Sales")
    let plant = Department(id: 3, name: "Plant")
    try departmentStore.saveAll([accounting, sales, plant])
    
    try sut.saveAll([
      User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: accounting, roles: []),
      User(id: 0, first: "Curly", last: "Stooge", email: "curly@stooges.com", username: "cstooge", password: "xyz987", department: sales, roles: []),
      User(id: 0, first: "Moe", last: "Stooge", email: "moe@stooges.com", username: "mstooge", password: "abc123", department: plant, roles: [])
    ])
    
    let users = try sut.findAll()
    #expect(try sut.count() == 3)
    #expect(users.map(\.id) == [1, 2, 3])
  }
  
  @Test func testFindAllEmpty() throws {
    let users = try sut.findAll()
    #expect(users.isEmpty)
    #expect(try sut.count() == 0)
  }
  
  @Test func testFindByID() throws {
    let accounting = Department(id: 1, name: "Accounting")
    try departmentStore.save(accounting)
    
    try sut.save(User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: accounting, roles: []))
    
    #expect(try sut.count() == 1)
    #expect(try sut.find(byID: 1) != nil)
    #expect(try sut.find(byID: 999) == nil)
  }
  
  @Test func testFindAllByIDs() throws {
    let accounting = Department(id: 1, name: "Accounting")
    let sales = Department(id: 2, name: "Sales")
    let plant = Department(id: 3, name: "Plant")
    try departmentStore.saveAll([accounting, sales, plant])
    
    try sut.saveAll([
      User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: accounting, roles: []),
      User(id: 0, first: "Curly", last: "Stooge", email: "curly@stooges.com", username: "cstooge", password: "xyz987", department: sales, roles: []),
      User(id: 0, first: "Moe", last: "Stooge", email: "moe@stooges.com", username: "mstooge", password: "abc123", department: plant, roles: [])
    ])
    
    #expect(try sut.count() == 3)
    
    var users = try sut.findAll(byIDs: [1, 3])
    #expect(users.count == 2)
    #expect(users.map(\.id) == [1, 3])
        
    users = try sut.findAll(byIDs: [1, 2, 3])
    #expect(users.count == 3)
    #expect(users.map(\.id) == [1, 2, 3])
        
    #expect(try sut.findAll(byIDs: []).isEmpty)
    #expect(try sut.findAll(byIDs: [100, 200]).isEmpty)
  }
  
  @Test func testSaveAll() throws {
    let accounting = Department(id: 1, name: "Accounting")
    let sales = Department(id: 2, name: "Sales")
    try departmentStore.saveAll([accounting, sales])
    
    try sut.saveAll([
      User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: accounting, roles: []),
      User(id: 0, first: "Curly", last: "Stooge", email: "curly@stooges.com", username: "cstooge", password: "xyz987", department: sales, roles: [])
    ])
    
    #expect(try sut.count() == 2)
    
    let users = try sut.findAll()
    #expect(users.count == 2)
    #expect(users.map(\.id) == [1, 2])
    #expect(users.map(\.first) == ["Larry", "Curly"])
  }
  
  @Test func testFindRealmObject() throws {
    let accounting = Department(id: 1, name: "Accounting")
    try departmentStore.save(accounting)
    
    try sut.save(User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: accounting, roles: []))
    
    let object = try sut.findRealmObject(byID: 1)
    
    #expect(object != nil)
    #expect(object?.id == 1)
    #expect(object?.first == "Larry")
  }
  
  @Test func testFindAllRealmObjects() throws {
    let accounting = Department(id: 1, name: "Accounting")
    let sales = Department(id: 2, name: "Sales")
    let plant = Department(id: 3, name: "Plant")
    try departmentStore.saveAll([accounting, sales, plant])
    
    try sut.saveAll([
      User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: accounting, roles: []),
      User(id: 0, first: "Curly", last: "Stooge", email: "curly@stooges.com", username: "cstooge", password: "xyz987", department: sales, roles: []),
      User(id: 0, first: "Moe", last: "Stooge", email: "moe@stooges.com", username: "mstooge", password: "abc123", department: plant, roles: [])
    ])
    
    #expect(try sut.count() == 3)
    
    let objects = try sut.findAllRealmObjects(byIDs: [1, 3])
    
    #expect(objects.count == 2)
    #expect(objects.map(\.id) == [1, 3])
    #expect(objects.map(\.first) == ["Larry", "Moe"])
    
    #expect((try sut.findAllRealmObjects(byIDs: [])).isEmpty)
    #expect((try sut.findAllRealmObjects(byIDs: [99, 100])).isEmpty)
  }
  
}
