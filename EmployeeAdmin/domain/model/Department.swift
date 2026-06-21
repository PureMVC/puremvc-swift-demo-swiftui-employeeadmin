//
//  Department.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation

struct Department: Identifiable, Hashable, Codable {
  var id: Int
  var name: String
  
  init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
  
  func isValid() -> Bool {
    id != 0 && name.isEmpty == false
  }
}

extension Department {
  static let empty = Department(id: 0, name: "--None Selected--")
}
