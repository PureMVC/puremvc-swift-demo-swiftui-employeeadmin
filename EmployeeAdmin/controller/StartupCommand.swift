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
    
    let configuration = URLSessionConfiguration.default
    configuration.allowsCellularAccess = true
    configuration.allowsConstrainedNetworkAccess = true
    configuration.allowsExpensiveNetworkAccess = true
    
    let session = URLSession(configuration: configuration)
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    facade.registerProxy(UserProxy(session: session, encoder: encoder, decoder: decoder))
    facade.registerProxy(RoleProxy(session: session, decoder: decoder))
    
    facade.registerMediator(UserListMediator())
    facade.registerMediator(UserFormMediator())
    facade.registerMediator(UserRoleMediator())
  }
    
}
