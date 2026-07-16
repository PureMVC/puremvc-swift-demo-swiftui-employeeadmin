//
//  StartupUseCase.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

struct StartupUseCase {
  
  let userStore: IUserStore
  let departmentStore: IDepartmentStore
  let roleStore: IRoleStore
  
  func execute() throws {
    guard try departmentStore.count() == 0 else {
      return
    }
    
    let departments = [
      .none,
      Department(id: 1, name: "Accounting"),
      Department(id: 2, name: "Sales"),
      Department(id: 3, name: "Plant"),
      Department(id: 4, name: "Shipping"),
      Department(id: 5, name: "Quality Control")
    ]
    try departmentStore.saveAll(departments)
    
    let roles = [
      Role(id: 1, name: "Administrator"),
      Role(id: 2, name: "Accounts Payable"),
      Role(id: 3, name: "Accounts Receivable"),
      Role(id: 4, name: "Employee Benefits"),
      Role(id: 5, name: "General Ledger"),
      Role(id: 6, name: "Payroll"),
      Role(id: 7, name: "Inventory"),
      Role(id: 8, name: "Production"),
      Role(id: 9, name: "Quality Control"),
      Role(id: 10, name: "Sales"),
      Role(id: 11, name: "Orders"),
      Role(id: 12, name: "Customers"),
      Role(id: 13, name: "Shipping"),
      Role(id: 14, name: "Returns")
    ]
    try roleStore.saveAll(roles)
    
    try userStore.saveAll([
      User(id: 0, first: "Larry", last: "Stooge", email: "larry@stooges.com", username: "lstooge", password: "ijk456", department: departments[1], roles: [roles[4], roles[6]]),
      User(id: 0, first: "Curly", last: "Stooge", email: "curly@stooges.com", username: "cstooge", password: "xyz987", department: departments[2], roles: [roles[3], roles[5]]),
      User(id: 0, first: "Moe", last: "Stooge", email: "moe@stooges.com", username: "mstooge", password: "abc123", department: departments[3], roles: [roles[8], roles[10], roles[13]])
    ])

  }
  
}
