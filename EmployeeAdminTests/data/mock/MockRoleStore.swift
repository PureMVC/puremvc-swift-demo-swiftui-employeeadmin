//
//  MockRoleData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import EmployeeAdmin

final class MockRoleStore: IRoleStore {
  
  private var data: Set<Role> = []
  
  private var userRoleIDs: [Int64: Set<Int64>] = [:]
  
  func findAll() throws -> Set<Role> {
    data
  }
  
  func findAll(byIDs ids: Set<Int64>) throws -> Set<Role> {
    data.filter { ids.contains($0.id) }
  }
  
  func find(byID id: Int64) throws -> Role? {
    data.first { $0.id == id }
  }
  
  func find(byUserID id: Int64) throws -> Set<Role> {
    let roleIDs = userRoleIDs[id] ?? []
    return data.filter { roleIDs.contains($0.id) }
  }
  
  func save(_ role: Role) throws {
    data.insert(role)
  }
  
  func saveAll(_ roles: Set<Role>) throws {
    data = roles
  }
  
  func count() throws -> Int {
    data.count
  }
  
  func assign(_ roles: Set<Role>, toUserID userID: Int64) {
    data.formUnion(roles)
    userRoleIDs[userID] = Set(roles.map(\.id))
  }
  
}
