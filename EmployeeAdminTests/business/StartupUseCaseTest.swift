//
//  StartupUseCaseTest.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Testing
@testable import EmployeeAdmin
import Foundation

@MainActor
struct StartupUseCaseTest {

  @Test func testExecute_seeds() throws {
    let departmentStore = MockDepartmentStore()
    let roleStore = MockRoleStore()
    let userStore = MockUserStore()
    let defaults = UserDefaults(suiteName: #function)!
    defaults.removePersistentDomain(forName: #function)
    let sut = StartupUseCase(userStore: userStore, departmentStore: departmentStore, roleStore: roleStore, defaults: defaults)
    
    try sut.execute()
    
    #expect((try departmentStore.findAll()).count == 6)
    #expect((try roleStore.findAll()).count == 14)
    #expect((try userStore.findAll()).count == 3)
  }
  
  @Test func testExecute_preSeeded() throws {
    let departmentStore = MockDepartmentStore()
    let roleStore = MockRoleStore()
    let userStore = MockUserStore()
    let defaults = UserDefaults(suiteName: #function)!
    defaults.removePersistentDomain(forName: #function)
    defaults.set(true, forKey: StartupUseCase.FIRST_LAUNCH)
    let sut = StartupUseCase(userStore: userStore, departmentStore: departmentStore, roleStore: roleStore, defaults: defaults)
        
    try departmentStore.save(.none)
    
    try sut.execute()
    
    #expect((try roleStore.findAll()).isEmpty)
    #expect((try userStore.findAll()).isEmpty)
  }
  
  @Test func testExecute_countSeeded() throws {
    let departmentStore = DepartmentStoreSpy()
    let roleStore = RoleStoreSpy()
    let userStore = UserStoreSpy()
    let defaults = UserDefaults(suiteName: #function)!
    defaults.removePersistentDomain(forName: #function)
    let sut = StartupUseCase(userStore: userStore, departmentStore: departmentStore, roleStore: roleStore, defaults: defaults)
    
    try sut.execute()
    
    #expect(departmentStore.countCalls == 0)
    #expect(departmentStore.saveAllCalls == 1)
    #expect(roleStore.saveAllCalls == 1)
    #expect(userStore.saveAllCalls == 1)
  }
  
  @Test func testExecute_countPreSeeded() throws {
    let departmentStore = DepartmentStoreSpy()
    let roleStore = RoleStoreSpy()
    let userStore = UserStoreSpy()
    let defaults = UserDefaults(suiteName: #function)!
    defaults.removePersistentDomain(forName: #function)
    defaults.set(true, forKey: StartupUseCase.FIRST_LAUNCH)

    let sut = StartupUseCase(userStore: userStore, departmentStore: departmentStore, roleStore: roleStore, defaults: defaults)
    
    try departmentStore.save(.none)
    
    try sut.execute()
    
    #expect(departmentStore.countCalls == 0)
    #expect(departmentStore.saveAllCalls == 0)
    #expect(roleStore.saveAllCalls == 0)
    #expect(userStore.saveAllCalls == 0)
  }

}
