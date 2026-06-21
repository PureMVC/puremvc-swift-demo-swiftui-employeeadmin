//
//  Role.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation

struct Role: Identifiable, Hashable, Codable {
  let id: Int
  let name: String
  
  init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}
