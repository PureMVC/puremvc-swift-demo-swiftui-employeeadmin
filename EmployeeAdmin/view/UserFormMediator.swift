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
  
  var user: UserVO = .empty
  var error: String?
  
  private var userProxy: IUserProxy?
  private var roleProxy: IRoleProxy?
  
  init() {
    super.init(name: UserFormMediator.NAME, viewComponent: nil)
    
    self.facade = ApplicationFacade.getInstance()
    facade?.removeMediator(UserFormMediator.NAME)
    facade?.registerMediator(self)
  }
  
  override func onRegister() {
    userProxy = facade?.retrieveProxy(UserProxy.NAME) as? IUserProxy
    roleProxy = facade?.retrieveProxy(RoleProxy.NAME) as? IRoleProxy
  }
   
  func findByUsername(_ username: String) {
    do {
      user = try userProxy?.findByUsername(username) ?? .empty
    } catch {
      self.error = error.localizedDescription
    }
  }
  
  func save(_ user: UserVO, roles: [RoleEnum]) {
    do {
      self.user = try userProxy?.save(user) ?? .empty
      roleProxy?.save(RoleVO(username: user.username, roles: roles))
    } catch {
      self.error = error.localizedDescription
    }
  }
  
  func update(_ user: UserVO, roles: [RoleEnum]) {
    do {
      self.user = try userProxy?.update(user) ?? .empty
      roleProxy?.update(RoleVO(username: user.username, roles: roles))
    } catch {
      self.error = error.localizedDescription
    }
  }

}
