//
//  UserProxy.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation
import Combine
import PureMVC

protocol IUserProxy: Proxy {
  func findAll() -> [UserVO]
  func findByUsername(_ username: String) throws -> UserVO
  @discardableResult func save(_ user: UserVO) throws -> UserVO
  @discardableResult func update(_ user: UserVO) throws -> UserVO
  func delete(_ user: UserVO)
}

class UserProxy: Proxy, IUserProxy {
    
  override class var NAME: String { "UserProxy" }
  
  init() {
    super.init(name: UserProxy.NAME, data: [])
  }
  
  func findAll() -> [UserVO] {
    users
  }
  
  func findByUsername(_ username: String) throws -> UserVO {
    guard let user = users.first(where: { $0.username == username } ) else {
      throw NSError(domain: "UserProxy", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found."])
    }
    
    return user
  }
  
  func save(_ user: UserVO) throws -> UserVO {
    var users = users
    guard users.contains(where: {$0.username == user.username}) == false else {
      throw NSError(domain: "UserProxy", code: 1, userInfo: [NSLocalizedDescriptionKey: "User already exists."])
    }
    
    users.append(user)
    data = users
    return user
  }
  
  func update(_ user: UserVO) throws -> UserVO {
    var users = users
    guard let index = users.firstIndex(where: {$0.username == user.username}) else {
      throw NSError(domain: "UserProxy", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found."])
    }
    
    users[index] = user
    data = users
    return user
  }
    
  func delete(_ user: UserVO) -> Void {
    var users = users
    users.removeAll { $0.username == user.username }
    data = users;
  }
  
  private var users: [UserVO] {
    get { data as? [UserVO] ?? [] }
    set { data = newValue }
  }
    
}
