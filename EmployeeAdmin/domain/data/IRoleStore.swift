//
//  IRoleData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

protocol IRoleStore {
  
  func findAll() throws -> [Role]
  
  func findAll(byIDs ids: [Int64]) throws -> [Role]
  
  func find(byID id: Int64) throws -> Role?
  
  func find(byUserID id: Int64) throws -> [Role]
  
  func save(_ role: Role) throws
  
  func saveAll(_ roles: [Role]) throws
  
  func count() throws -> Int
  
}
