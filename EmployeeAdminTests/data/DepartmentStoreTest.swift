//
//  DepartmentTest.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Testing
@testable import EmployeeAdmin
import RealmSwift

@MainActor
struct DepartmentStoreTest {
  
  private let configuration: Realm.Configuration
  private var sut: DepartmentStore!
  
  init() throws {
    configuration = try ApplicationPersistence(inMemory: true).configuration
    sut = DepartmentStore(configuration: configuration)
  }

  @Test func testFindAll() throws {
    let accounting = Department(id: 1, name: "Accounting")
    let sales = Department(id: 2, name: "Sales")
    let plant = Department(id: 3, name: "Plant")
    try sut.saveAll([accounting, sales, plant])
    
    let departments = try sut.findAll()
    #expect(try sut.count() == 3)
    #expect(departments == [accounting, sales, plant])
  }
  
  @Test func testFindAllEmpty() throws {
    let departments = try sut.findAll()
    #expect(departments.isEmpty)
    #expect(try sut.count() == 0)
  }
  
  @Test func testFindByID() throws {
    try sut.saveAll([Department(id: 1, name: "Accounting")])
    #expect(try sut.find(byID: 1) != nil)
    #expect(try sut.find(byID: 999) == nil)
  }
  
  @Test func testFindAllByIDs() throws {
    let accounting = Department(id: 1, name: "Accounting")
    let sales = Department(id: 2, name: "Sales")
    let plant = Department(id: 3, name: "Plant")
    try sut.saveAll([accounting, sales, plant])
    
    #expect((try sut.findAll(byIDs: [1, 3])) == [accounting, plant])
    #expect((try sut.findAll(byIDs: [1, 2, 3])) == [accounting, sales, plant])
    
    #expect(try sut.findAll(byIDs: []).isEmpty)
    #expect(try sut.findAll(byIDs: [100, 200]).isEmpty)
  }
  
  @Test func testSave() throws {
    let accounting = Department(id: 1, name: "Accounting")
    try sut.save(accounting)
        
    #expect(try sut.count() == 1)
    #expect((try sut.find(byID: 1)) == accounting)
    
    let sales = Department(id: 2, name: "Sales")
    try sut.save(sales)
    
    #expect(try sut.count() == 2)
    #expect((try sut.find(byID: 2)) == sales)
  }
  
  @Test func testSaveAll() throws {
    let departments = [
      Department(id: 1, name: "Accounting"),
      Department(id: 2, name: "Sales")
    ]
    
    try sut.saveAll(departments)
    #expect(try sut.count() == 2)
  }
  
  @Test func testFindRealmObject() throws {
    try sut.saveAll([
      Department(id: 1, name: "Accounting")
    ])
    
    let object = try sut.findRealmObject(byID: 1)
    
    #expect(object != nil)
    #expect(object?.id == 1)
  }
  
  @Test func testFindAllRealmObjects() throws {
    try sut.saveAll([
      Department(id: 1, name: "Accounting"),
      Department(id: 2, name: "Sales"),
      Department(id: 3, name: "Engineering")
    ])
    
    let objects = try sut.findAllRealmObjects(byIDs: [1, 3])
    
    #expect(objects.count == 2)
    #expect(objects.map(\.id) == [1, 3])
    #expect(objects.map(\.name) == ["Accounting", "Engineering"])
    
    #expect((try sut.findAllRealmObjects(byIDs: [])).isEmpty)
    #expect((try sut.findAllRealmObjects(byIDs: [99, 100])).isEmpty)
  }
  
}
