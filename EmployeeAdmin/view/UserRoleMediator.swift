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
  
  var selection: [RoleEnum] = []
  
  private var roleProxy: IRoleProxy?
  
  init() {
    super.init(name: UserRoleMediator.NAME, viewComponent: nil)
    
    self.facade = ApplicationFacade.getInstance()
    facade?.removeMediator(UserRoleMediator.NAME)
    facade?.registerMediator(self)
  }
  
  override func onRegister() {
    roleProxy = facade?.retrieveProxy(RoleProxy.NAME) as? IRoleProxy
  }
  
  func findByUsername(_ username: String) {
    selection = roleProxy?.findByUsername(username) ?? []
  }
}
