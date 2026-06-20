//
//  UserListMediator.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Observation
import PureMVC

@Observable
class UserListMediator: Mediator {
  override class var NAME: String { "UserListMediator" }
  
  var users: [User] = []
  var error: Error?
  var isLoading = false
  
  private var userProxy: IUserProxy?
  
  init() {
    super.init(name: UserListMediator.NAME, viewComponent: nil)
  }
  
  override func onRegister() {
    userProxy = facade?.retrieveProxy(UserProxy.NAME) as? IUserProxy
  }
  
  func findAll() async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      users = try await userProxy?.findAll() ?? []
    } catch {
      self.error = error
    }
  }
  
  func deleteById(_ id: Int) async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      try await userProxy?.deleteById(id)
    } catch {
      self.error = error
    }
  }
}
