//
//  MockDepartmentData.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import EmployeeAdmin

final class MockDepartmentStore: IDepartmentStore {
  
  private var data: Set<Department> = []
  
  func findAll() throws -> Set<Department> {
    data
  }
  
  func findAll(byIDs ids: Set<Int64>) throws -> Set<Department> {
    data.filter { ids.contains($0.id) }
  }
  
  func find(byID id: Int64) throws -> Department? {
    data.first { $0.id == id }
  }
  
  func save(_ department: Department) throws {
    data = Set([department])
  }
  
  func saveAll(_ departments: Set<Department>) throws {
    data = departments
  }
  
  func count() throws -> Int {
    data.count
  }
}
