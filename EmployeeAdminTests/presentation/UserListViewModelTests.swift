//
//  UserListViewModelTests.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Testing
@testable import EmployeeAdmin

@MainActor
struct UserListViewModelTests {
  
  private let userStore: MockUserStore
  private let departmentStore: MockDepartmentStore
  private let sut: UserFormViewModel
  
  init() {
    userStore = MockUserStore()
    departmentStore = MockDepartmentStore()
    
    sut = UserFormViewModel(userStore: userStore, departmentStore: departmentStore)
  }

  @Test func testFindAll() async throws {
    try userStore.saveAll([
      User(id: 1, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: .none, roles: []),
      User(id: 2, first: "Curly", last: "Stooge", email: "curly@stooges.com", username: "cstooge", password: "xyz987", department: .none, roles: []),
      User(id: 3, first: "Moe", last: "Stooge", email: "moe@stooges.com", username: "mstooge", password: "abc123", department: .none, roles: [])
    ])
    
    let sut = UserListViewModel(userStore: userStore)
    
    await sut.findAll()
    
    #expect(sut.users.count == 3)
    #expect(sut.users.map(\.id) == [1, 2, 3])
    #expect(sut.users.map(\.username) == ["lstooge", "cstooge", "mstooge"])
    #expect(sut.users.map(\.first) == ["Larry", "Curly", "Moe"])
    #expect(sut.loading == false)
    #expect(sut.error == nil)
  }
  
  @Test func testDeleteByID() async throws {
    let larry = try userStore.save(
      User(id: 1, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: .none, roles: [])
    )
    
    let sut = UserListViewModel(userStore: userStore)
    
    await sut.findAll()
    #expect(sut.users.count == 1)
    
    await sut.delete(byID: larry.id)
    await sut.findAll()
    
    #expect(sut.users.isEmpty)
    #expect(sut.loading == false)
    #expect(sut.error == nil)
  }

}
