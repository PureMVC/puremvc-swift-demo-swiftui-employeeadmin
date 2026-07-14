//
//  UserRoleViewModelTests.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Testing
@testable import EmployeeAdmin

@MainActor
struct UserRoleViewModelTests {
  
  private let roleStore: MockRoleStore
  private let sut: UserRoleViewModel
  
  init() {
    roleStore = MockRoleStore()
    sut = UserRoleViewModel(roleStore: roleStore)
  }

  @Test func testFindAll() async throws {
    try roleStore.saveAll([
      Role(id: 1, name: "Administrator"),
      Role(id: 2, name: "Accounts Payable"),
      Role(id: 3, name: "Accounts Receivable")
    ])
        
    await sut.findAll()
    
    #expect(sut.roles.count == 3)
    #expect(sut.roles.sorted {$0.id < $1.id}.map(\.id) == [1, 2, 3])
    #expect(sut.roles.sorted {$0.id < $1.id}.map(\.name) == ["Administrator", "Accounts Payable", "Accounts Receivable"])
    #expect(sut.loading == false)
    #expect(sut.error == nil)
  }
  
  @Test func testFindByUserID() async throws {
    let administrator = Role(id: 1, name: "Administrator")
    let payroll = Role(id: 6, name: "Payroll")
    
    roleStore.assign(
      [administrator, payroll],
      toUserID: 10
    )
    
    await sut.find(byUserID: 10)
    
    #expect(sut.selection.count == 2)
    #expect(sut.selection.sorted {$0.id < $1.id} == [administrator, payroll])
    
    #expect(sut.roles.isEmpty)
    #expect(sut.loading == false)
    #expect(sut.error == nil)
  }

}
