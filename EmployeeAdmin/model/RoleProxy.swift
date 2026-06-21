//
//  RoleProxy.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation
import Combine
import PureMVC

protocol IRoleProxy: Proxy {
  func findByUsername(_ username: String) -> [RoleEnum]
  func save(_ role: RoleVO)
  func update(_ role: RoleVO)
}

class RoleProxy: Proxy, IRoleProxy {
    
  override class var NAME: String { "RoleProxy" }
  
  init() {
    super.init(name: RoleProxy.NAME, data: [])
  }
  
  func findByUsername(_ username: String) -> [RoleEnum] {
    guard let result = roles.first(where: {$0.username == username}) else {
      fatalError("User not found.")
    }
    
    return result.roles
  }
  
  func save(_ role: RoleVO) {
    var roles = roles;
    roles.append(role)
    data = roles
  }
  
  func update(_ role: RoleVO) {
    var roles = roles
    guard let index = roles.firstIndex(where: {$0.username == role.username}) else {
      fatalError("User not found.")
    }
    
    roles[index].roles = role.roles
    data = roles
  }
    
  private var roles: [RoleVO] {
    get { data as? [RoleVO] ?? [] }
    set { data = newValue }
  }
}
