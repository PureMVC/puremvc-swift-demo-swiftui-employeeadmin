//
//  RoleVO.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

struct RoleVO {
  var username: String
  var roles: [RoleEnum]
  
  init(username: String, roles: [RoleEnum]) {
    self.username = username
    self.roles = roles
  }
}
