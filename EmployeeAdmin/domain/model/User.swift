//
//  User.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

struct User: Identifiable, Hashable, Codable {
    
  var id: Int
  var username: String
  var first: String
  var last: String
  var email: String
  var password: String
  var department: Department
  var roles: [Role]
  
  init(id: Int, username: String, first: String, last: String, email: String, password: String, department: Department, roles: [Role]) {
    self.id = id
    self.username = username
    self.first = first
    self.last = last
    self.email = email
    self.password = password
    self.department = department
    self.roles = roles
  }
  
  func isValid(confirm: String?) -> Bool {
    [username, first, last, email, password].allSatisfy { $0.isEmpty == false }
    && password == confirm
    && department.isValid() == true
  }
  
  var givenName: String { "\(last), \(first)" }
}

extension User {
  static let empty = User(id: 0, username: "", first: "", last: "", email: "", password: "", department: .empty, roles: [])
}
