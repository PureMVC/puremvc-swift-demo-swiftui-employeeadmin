//
//  IUserData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

protocol IUserStore {
  
  func findAll() throws -> [User]
  
  func findAll(byIDs ids: [Int64]) throws -> [User]
  
  func find(byID id: Int64) throws -> User?
  
  @discardableResult
  func save(_ user: User) throws -> User
  
  @discardableResult
  func saveAll(_ users: [User]) throws -> [User]
  
  func delete(_ user: User) throws
  
  func delete(byID id: Int64) throws
  
  func deleteAll() throws
  
  func deleteAll(_ users: [User]) throws
  
  func deleteAll(byIDs ids: [Int64]) throws
  
  func count() throws -> Int
  
}
