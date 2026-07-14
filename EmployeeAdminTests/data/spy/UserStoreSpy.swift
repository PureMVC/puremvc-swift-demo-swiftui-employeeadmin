//
//  UserDataSpy.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import EmployeeAdmin

final class UserStoreSpy: IUserStore {
  
  private(set) var saveAllCalls = 0
  
  private var data: [User] = []
  
  func findAll() throws -> [User] {
    data
  }
  
  func findAll(byIDs ids: Set<Int64>) throws -> [User] {
    data.filter { ids.contains($0.id) }
  }
  
  func find(byID id: Int64) throws -> User? {
    data.first { $0.id == id }
  }
  
  @discardableResult
  func save(_ user: User) throws -> User {
    if let index = data.firstIndex(where: { $0.id == user.id }) {
      data[index] = user
    } else {
      data.append(user)
    }
    return user
  }
  
  @discardableResult
  func saveAll(_ users: [User]) throws -> [User] {
    saveAllCalls += 1
    data = users
    return users
  }
  
  func delete(_ user: User) throws {
    data.removeAll { $0.id == user.id }
  }
  
  func delete(byID id: Int64) throws {
    data.removeAll { $0.id == id }
  }
  
  func deleteAll() throws {
    data.removeAll()
  }
  
  func deleteAll(_ users: [User]) throws {
    let ids = Set(users.map(\.id))
    data.removeAll { ids.contains($0.id) }
  }
  
  func deleteAll(byIDs ids: Set<Int64>) throws {
    data.removeAll { ids.contains($0.id) }
  }
  
  func count() throws -> Int {
    data.count
  }
}
