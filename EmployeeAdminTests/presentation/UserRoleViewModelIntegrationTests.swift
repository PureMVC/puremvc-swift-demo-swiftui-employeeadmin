//
//  UserRoleViewModelIntegrationTests.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Testing
import CoreData
@testable import EmployeeAdmin

@MainActor
struct UserRoleViewModelIntegrationTests {
  
  private let context: NSManagedObjectContext
  private let userStore: IUserStore
  private let departmentStore: IDepartmentStore
  private let roleStore: IRoleStore
  private let sut: UserRoleViewModel
  
  init() {
    context = ApplicationPersistence(inMemory: true).container.newBackgroundContext()
    
    departmentStore = DepartmentStore(context: context)
    roleStore = RoleStore(context: context)
    userStore = UserStore(departmentStore: departmentStore as! DepartmentStore, roleStore: roleStore as! RoleStore, context: context)
    
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
    try departmentStore.save(.none)
    
    let roles = [
      Role(id: 1, name: "Administrator"),
      Role(id: 2, name: "Accounts Payable"),
      Role(id: 3, name: "Accounts Receivable"),
      Role(id: 4, name: "Employee Benefits"),
      Role(id: 5, name: "General Ledger"),
      Role(id: 6, name: "Payroll")
    ]
    try roleStore.saveAll(roles)
    
    let larry = try userStore.save(User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: .none, roles: [roles[3], roles[5]]))
    
    try userStore.save(larry)
    
    await sut.find(byUserID: larry.id)
        
    #expect(sut.selection.count == 2)
    #expect(sut.selection.sorted {$0.id < $1.id}.map(\.id) == [4, 6])
    #expect(sut.selection.sorted {$0.id < $1.id}.map(\.name) == ["Employee Benefits", "Payroll"])
    #expect(sut.loading == false)
    #expect(sut.error == nil)
  }

}
