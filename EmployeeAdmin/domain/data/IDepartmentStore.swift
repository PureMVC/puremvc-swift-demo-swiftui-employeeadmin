//
//  IDepartmentData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

protocol IDepartmentStore {
  
  func findAll() throws -> [Department]
  
  func findAll(byIDs ids: [Int64]) throws -> [Department]
  
  func find(byID id: Int64) throws -> Department?
  
  func save(_ department: Department) throws
  
  func saveAll(_ departments: [Department]) throws
  
  func count() throws -> Int
  
}
