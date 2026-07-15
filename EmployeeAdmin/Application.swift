//
//  EmployeeAdmin.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import PureMVC

@main
struct Application: App {
    
  init() {
    ApplicationFacade.getInstance().startup()
  }

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        UserList()
      }
    }
  }
}
