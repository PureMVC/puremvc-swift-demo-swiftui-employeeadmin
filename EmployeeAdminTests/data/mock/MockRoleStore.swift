//
//  MockRoleData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import EmployeeAdmin

final class MockRoleStore: IRoleStore {
  
  private var data: [Role] = []
  
  private var userRoleIDs: [Int64: [Int64]] = [:]
  
  func findAll() throws -> [Role] {
    data
  }
  
  func findAll(byIDs ids: [Int64]) throws -> [Role] {
    data.filter { ids.contains($0.id) }
  }
  
  func find(byID id: Int64) throws -> Role? {
    data.first { $0.id == id }
  }
  
  func find(byUserID id: Int64) throws -> [Role] {
    let roleIDs = userRoleIDs[id] ?? []
    return data.filter { roleIDs.contains($0.id) }
  }
  
  func save(_ role: Role) throws {
    data.append(role)
  }
  
  func saveAll(_ roles: [Role]) throws {
    data = roles
  }
  
  func count() throws -> Int {
    data.count
  }
  
  func assign(_ roles: [Role], toUserID userID: Int64) {
    for role in roles where !data.contains(role) {
      data.append(role)
    }
    
    userRoleIDs[userID] = roles.map(\.id)
  }
  
}
