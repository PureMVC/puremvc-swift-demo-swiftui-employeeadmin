//
//  EmployeeAdmin.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import PureMVC

let facade = ApplicationFacade.getInstance()

@main
struct EmployeeAdmin: App {
    
  init() {
    facade.startup()
  }

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        UserList()
      }
    }
  }
}
