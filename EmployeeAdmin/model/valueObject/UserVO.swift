//
//  UserVO.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation

struct UserVO: Hashable {
    
  var username: String
  var first: String
  var last: String
  var email: String
  var password: String
  var department: DeptEnum
  
  init(username: String, first: String, last: String, email: String, password: String, department: DeptEnum) {
    self.username = username
    self.first = first
    self.last = last
    self.email = email
    self.password = password
    self.department = department
  }
  
  func isValid(confirm: String?) -> Bool {
    [username, first, last, email, password].allSatisfy { $0.isEmpty == false } && password == confirm && department != .noneSelected
  }
  
  var givenName: String { "\(last), \(first)" }
}

extension UserVO {
  static let empty = UserVO(username: "", first: "", last: "", email: "", password: "", department: .noneSelected)
}
