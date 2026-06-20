//
//  UserRoleMediator.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Observation
import PureMVC

@Observable
class UserRoleMediator: Mediator {
  override class var NAME: String { "UserRoleMediator" }
  
  var roles: [Role] = []
  var selection: [Role] = []
  var isLoading = false
  var error: Error?
  
  private var roleProxy: IRoleProxy?
  
  init() {
    super.init(name: UserRoleMediator.NAME, viewComponent: nil)
  }
  
  override func onRegister() {
    roleProxy = facade?.retrieveProxy(RoleProxy.NAME) as? IRoleProxy
  }
  
  func findAll() async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      roles = try await roleProxy?.findAll() ?? []
    } catch {
      self.error = error
    }
  }
  
  func findByUserId(_ id: Int) async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      selection = try await roleProxy?.findByUserId(id) ?? []
    } catch {
      self.error = error
    }
  }
}
