//
//  UserFormMediator.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Observation
import PureMVC

@Observable
class UserFormMediator: Mediator {
  override class var NAME: String { "UserFormMediator" }
  
  var departments: [Department] = []
  var user: User = .empty
  var isLoading = false
  var error: Error?
  
  private var userProxy: IUserProxy?
  
  init() {
    super.init(name: UserFormMediator.NAME, viewComponent: nil)
  }
  
  override func onRegister() {
    userProxy = facade?.retrieveProxy(UserProxy.NAME) as? IUserProxy
  }
  
  func findAllDepartments() async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      departments = try await userProxy?.findAllDepartments() ?? []
    } catch {
      self.error = error
    }
  }
  
  func findById(_ id: Int) async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      user = try await userProxy?.findById(id) ?? .empty
    } catch {
      self.error = error
    }
  }
  
  func saveOrUpdate(_ user: User) async {
    do {
      if (user.id == 0) {
        self.user = try await userProxy?.save(user) ?? .empty
      } else {
        self.user = try await userProxy?.update(user) ?? .empty
      }
    } catch {
      self.error = error
    }
  }

}
