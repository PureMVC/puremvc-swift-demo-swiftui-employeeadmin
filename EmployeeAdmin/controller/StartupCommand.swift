//
//  StartupCommand.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation
import PureMVC

class StartupCommand: SimpleCommand {
    
  override func execute(_ notification: INotification) {
    guard let facade else { fatalError("Facade not initialized.") }
    
    let userProxy: IUserProxy = UserProxy();
    do {
      try userProxy.save(UserVO(username: "lstooge", first: "Larry", last: "Stooge", email: "larry@stooges.com", password: "ijk456", department: .accounting))
      try userProxy.save(UserVO(username: "cstooge", first: "Curly", last: "Stooge", email: "curly@stooges.com", password: "xyz987", department: .sales))
      try userProxy.save(UserVO(username: "mstooge", first: "Moe", last: "Stooge", email: "moe@stooges.com", password: "abc123", department: .plant))
      facade.registerProxy(userProxy)
    } catch {
      print(error)
      return
    }

    let roleProxy: IRoleProxy = RoleProxy()
    roleProxy.save(RoleVO(username: "lstooge", roles: [.payroll, .employeeBenefits]))
    roleProxy.save(RoleVO(username: "cstooge", roles: [.accountsPayable, .accountsReceivable, .generalLedger]))
    roleProxy.save(RoleVO(username: "mstooge", roles: [.inventory, .production, .sales, .shipping]))
    facade.registerProxy(roleProxy)
  }
    
}
