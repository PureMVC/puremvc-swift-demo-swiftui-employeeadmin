//
//  Department.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

struct Department: Identifiable, nonisolated Hashable {
  let id: Int64
  let name: String
  
  static let none = Department(id: 0, name: "--None Selected--")
}
