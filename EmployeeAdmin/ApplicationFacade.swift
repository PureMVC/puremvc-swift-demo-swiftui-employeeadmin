//
//  ApplicationFacade.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import PureMVC

class ApplicationFacade: Facade {
    
  static let KEY: String = "EmployeeAdmin"
  
  static let STARTUP = "startup"
  
  override func initializeController() {
    super.initializeController()
    registerCommand(ApplicationFacade.STARTUP) { StartupCommand() }
  }
  
  class func getInstance() -> ApplicationFacade {
    guard let facade = Facade.getInstance(KEY, factory: { k in ApplicationFacade(key: k) }) as? ApplicationFacade else {
      fatalError("Expected ApplicationFacade for key '\(KEY)'")
    }
    
    return facade
  }
  
  func startup() {
    sendNotification(ApplicationFacade.STARTUP)
  }
  
}
