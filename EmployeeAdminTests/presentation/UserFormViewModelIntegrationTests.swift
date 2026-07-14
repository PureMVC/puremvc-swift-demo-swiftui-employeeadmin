//
//  UserFormViewModelIntegrationTests.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Testing
import CoreData
@testable import EmployeeAdmin

@MainActor
struct UserFormViewModelIntegrationTests {
  
  private let context: NSManagedObjectContext
  private let userStore: IUserStore
  private let departmentStore: IDepartmentStore
  private let roleStore: IRoleStore
  private let sut: UserFormViewModel
  
  init() {
    context = ApplicationPersistence(inMemory: true).container.newBackgroundContext()
    
    departmentStore = DepartmentStore(context: context)
    roleStore = RoleStore(context: context)
    userStore = UserStore(departmentStore: departmentStore as! DepartmentStore, roleStore: roleStore as! RoleStore, context: context)
    
    sut = UserFormViewModel(userStore: userStore, departmentStore: departmentStore)
  }

  @Test func testFindById() async throws {
    let accounting = Department(id: 1, name: "Accounting")
    try departmentStore.save(accounting)
    
    let larry = try userStore.save(User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: accounting, roles: []))

    await sut.find(byId: larry.id)
    
    #expect(sut.user.id == larry.id)
    #expect(sut.user.first == "Larry")
    #expect(sut.loading == false)
    #expect(sut.error == nil)
  }
  
  @Test func testSave() async throws {
    let accounting = Department(id: 1, name: "Accounting")
    try departmentStore.save(accounting)
    
    let administrator = Role(id: 1, name: "Administrator")
    try roleStore.save(administrator)

    sut.user = .empty
    sut.user.username = "lstooge"
    sut.user.first = "Larry"
    sut.user.last = "Stooge"
    sut.user.email = "larry@stooges.com"
    sut.user.password = "ijk456"
    sut.user.department = accounting
    
    await sut.save(selection: [administrator])

    let user = try userStore.find(byID: sut.user.id)
    #expect(user != nil)
    #expect(user!.username == "lstooge")
    #expect(user!.first == "Larry")
    #expect(user!.last == "Stooge")
    #expect(user!.email == "larry@stooges.com")
    #expect(user!.password == "ijk456")
    #expect(user!.department == accounting)
    #expect(user?.roles.contains(administrator) == true)
  }
  
  @Test func testFindAllDepartments() async throws {
    let accounting = Department(id: 1, name: "Accounting")
    let sales = Department(id: 2, name: "Sales")
    let plant = Department(id: 3, name: "Plant")
    try departmentStore.saveAll([accounting, sales, plant])
    
    await sut.findAllDepartments()
    
    #expect(sut.departments.count == 3)
    #expect(sut.departments.contains(accounting))
    #expect(sut.departments.contains(sales))
    #expect(sut.departments.contains(plant))
    #expect(sut.departments.sorted { $0.id < $1.id }.map(\.name) == ["Accounting", "Sales", "Plant"])
  }

}
