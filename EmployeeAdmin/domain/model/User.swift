//
//  User.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation

struct User: Identifiable, Hashable {
  var id: Int64
  var first: String
  var last: String
  var email: String
  var username: String
  var password: String
  var department: Department
  var roles: [Role]?
  
  static let empty = User(id: 0, first: "", last: "", email: "", username: "", password: "", department: .none, roles: nil)
}

extension User {
  
  func isValid(confirm: String?) -> Bool {
    [username, first, last, email, password].allSatisfy { $0.isEmpty == false } &&
    password == confirm &&
    department != .none
  }
  
  var givenName: String { "\(last), \(first)" }
  
}
