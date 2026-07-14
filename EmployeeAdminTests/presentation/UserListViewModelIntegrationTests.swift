//
//  UserListViewModelIntegrationTests.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Testing
@testable import EmployeeAdmin
import RealmSwift

@MainActor
struct UserListViewModelIntegrationTests {
  
  private let configuration: Realm.Configuration
  private let userStore: IUserStore
  private let departmentStore: IDepartmentStore
  private let roleStore: IRoleStore
  private let sut: UserListViewModel
  
  init() throws {
    configuration = try ApplicationPersistence(inMemory: true).configuration
    
    departmentStore = DepartmentStore(configuration: configuration)
    roleStore = RoleStore(configuration: configuration)
    userStore = UserStore(departmentStore: departmentStore as! DepartmentStore, roleStore: roleStore as! RoleStore, configuration: configuration)
    
    sut = UserListViewModel(userStore: userStore)
  }

  @Test func testFindAll() async throws {
    let accounting = Department(id: 1, name: "Accounting")
    let sales = Department(id: 2, name: "Sales")
    let plant = Department(id: 3, name: "Plant")
    try departmentStore.saveAll([accounting, sales, plant])
    
    try userStore.saveAll([
      User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: accounting, roles: []),
      User(id: 0, first: "Curly", last: "Stooge", email: "curly@stooges.com", username: "cstooge", password: "xyz987", department: sales, roles: []),
      User(id: 0, first: "Moe", last: "Stooge", email: "moe@stooges.com", username: "mstooge", password: "abc123", department: plant, roles: [])
    ])
          
    await sut.findAll()
    
    #expect(sut.users.count == 3)
    #expect(sut.users.map(\.id) == [1, 2, 3])
    #expect(sut.users.map(\.username) == ["lstooge", "cstooge", "mstooge"])
    #expect(sut.users.map(\.first) == ["Larry", "Curly", "Moe"])
    #expect(sut.loading == false)
    #expect(sut.error == nil)
  }
  
  @Test func testDeleteByID() async throws {
    let accounting = Department(id: 1, name: "Accounting")
    try departmentStore.save(accounting)
    
    let larry = try userStore.save(User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: accounting, roles: []))
    
    await sut.findAll()
    #expect(sut.users.count == 1)
    
    await sut.delete(byID: larry.id)
    await sut.findAll()
    
    #expect(sut.users.isEmpty)
    #expect(sut.loading == false)
    #expect(sut.error == nil)
  }

}
