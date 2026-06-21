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
  
  var users: [UserVO] = []
  
  private var userProxy: IUserProxy?
  
  init() {
    super.init(name: UserListMediator.NAME, viewComponent: nil)
  }
  
  override func onRegister() {
    userProxy = facade?.retrieveProxy(UserProxy.NAME) as? IUserProxy
  }
  
  func findAll() async {
    users = userProxy?.findAll() ?? []
  }
  
  func delete(_ user: UserVO) {
    userProxy?.delete(user)
  }
}
