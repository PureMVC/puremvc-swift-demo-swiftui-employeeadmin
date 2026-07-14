//
//  RoleTest.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Testing
import RealmSwift
@testable import EmployeeAdmin

@MainActor
struct RoleStoreTest {
  
  private let configuration: Realm.Configuration
  private var sut: RoleStore!
  
  init() throws {
    configuration = try ApplicationPersistence(inMemory: true).configuration
    sut = RoleStore(configuration: configuration)
  }
  
  @Test func testFindAll() throws {
    let administrator = Role(id: 1, name: "Administrator")
    let accountsPayable = Role(id: 2, name: "Accounts Payable")
    let accountsReceivable = Role(id: 3, name: "Accounts Receivable")
    
    try sut.saveAll([
      administrator,
      accountsPayable,
      accountsReceivable
    ])
    
    let roles = try sut.findAll()
    #expect(try sut.count() == 3)
    #expect(roles == [administrator, accountsPayable, accountsReceivable])
  }

  @Test func testFindAllEmpty() throws {
    let roles = try sut.findAll()
    #expect(roles.isEmpty)
    #expect(try sut.count() == 0)
  }
  
  @Test func testFindByID() throws {
    try sut.saveAll([Role(id: 1, name: "Administrator")])
    #expect(try sut.find(byID: 1) != nil)
    #expect(try sut.find(byID: 999) == nil)
  }
  
  @Test func testFindAllByIDs() throws {
    let administrator = Role(id: 1, name: "Administrator")
    let accountsPayable = Role(id: 2, name: "Accounts Payable")
    let accountsReceivable = Role(id: 3, name: "Accounts Receivable")
    
    try sut.saveAll([
      administrator,
      accountsPayable,
      accountsReceivable
    ])
        
    #expect(try sut.findAll(byIDs: [1, 3]) == [administrator, accountsReceivable])
    #expect((try sut.findAll(byIDs: [1, 2, 3])) == [administrator, accountsPayable, accountsReceivable])
    
    #expect(try sut.findAll(byIDs: []).isEmpty)
    #expect(try sut.findAll(byIDs: [100, 200]).isEmpty)
  }
  
  @Test func testSave() throws {
    let administrator = Role(id: 1, name: "Administrator")
    try sut.save(administrator)
    
    #expect(try sut.count() == 1)
    #expect((try sut.find(byID: 1)) == administrator)
    
    let accountsPayable = Role(id: 2, name: "Accounts Payable")
    try sut.save(accountsPayable)
    
    #expect(try sut.count() == 2)
    #expect((try sut.find(byID: 2)) == accountsPayable)
  }
  
  @Test func testSaveAll() throws {
    let roles = [
      Role(id: 1, name: "Administrator"),
      Role(id: 2, name: "Accounts Payable")
    ]
    
    try sut.saveAll(roles)
    #expect(try sut.count() == 2)
  }
  
  @Test func testFindManagedObject() throws {
    try sut.saveAll([
      Role(id: 1, name: "Administrator")
    ])
    
    let object = try sut.findRealmObject(byID: 1)
    
    #expect(object != nil)
    #expect(object?.id == 1)
  }
  
  @Test func testFindAllRealmObjects() throws {
    try sut.saveAll([
      Role(id: 1, name: "Administrator"),
      Role(id: 2, name: "Accounts Payable"),
      Role(id: 3, name: "Accounts Receivable")
    ])
    
    let objects = try sut.findAllRealmObjects(byIDs: [1, 3])
    
    #expect(objects.count == 2)
    #expect(objects.map(\.id) == [1, 3])
    #expect(objects.map(\.name) == ["Administrator", "Accounts Receivable"])
    
    #expect((try sut.findAllRealmObjects(byIDs: [])).isEmpty)
    #expect((try sut.findAllRealmObjects(byIDs: [99, 100])).isEmpty)
  }
  
}
