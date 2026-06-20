//
//  ApplicationFacade.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import PureMVC

class ApplicationFacade: Facade {
    
  static let KEY: String = "EmployeeAdmin"
  
  static let STARTUP = "startup"
  
  override func initializeController() {
    super.initializeController()
    registerCommand(ApplicationFacade.STARTUP) { StartupCommand() }
  }
  
  class func getInstance(key: String) -> ApplicationFacade {
    guard let facade = Facade.getInstance(key, factory: { k in ApplicationFacade(key: k) }) as? ApplicationFacade else {
      fatalError("Expected ApplicationFacade for key '\(key)'")
    }
    
    return facade
  }
  
  func startup() {
    sendNotification(ApplicationFacade.STARTUP)
  }
  
}
