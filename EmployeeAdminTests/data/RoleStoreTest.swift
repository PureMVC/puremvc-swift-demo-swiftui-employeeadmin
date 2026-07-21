//
//  RoleTest.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Testing
@testable import EmployeeAdmin
import CoreData

@MainActor
struct RoleStoreTest {
  
  private let context: NSManagedObjectContext
  private var sut: RoleStore!
  
  init() {
    context = ApplicationPersistence(inMemory: true).container.newBackgroundContext()
    sut = RoleStore(context: context)
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
    
    let object = try RoleManagedObject.find(byID: 1, in: context)
    
    #expect(object != nil)
    #expect(object?.id == 1)
  }
  
  @Test func testFindAllManagedObjects() throws {
    try sut.saveAll([
      Role(id: 1, name: "Administrator"),
      Role(id: 2, name: "Accounts Payable"),
      Role(id: 3, name: "Accounts Receivable")
    ])
    
    
    let objects = try RoleManagedObject.findAll(matching: NSPredicate(format: "id IN %@", [1, 3]), in: context)
    
    #expect(objects.count == 2)
    #expect(Set(objects.map(\.id)) == [1, 3])
    #expect(Set(objects.map(\.name)) == ["Administrator", "Accounts Receivable"])
    
    #expect(try RoleManagedObject.findAll(matching: NSPredicate(format: "id IN %@", []), in: context).isEmpty)
    #expect(try RoleManagedObject.findAll(matching: NSPredicate(format: "id IN %@", [99, 100]), in: context).isEmpty)
  }
  
}
