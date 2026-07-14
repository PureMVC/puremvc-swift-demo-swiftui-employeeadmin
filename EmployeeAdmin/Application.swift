//
//  EmployeeAdmin.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import RealmSwift

@main
struct EmployeeAdmin: App {
  
  let persistence: ApplicationPersistence
  let container: ApplicationContainer
    
  @State private var initialized = false
   
  init() {
    persistence = .shared
    container = ApplicationContainer(configuration: .defaultConfiguration)
  }

  var body: some Scene {
    WindowGroup {
      if initialized {
        NavigationStack {
          UserList(viewModel: container.userListViewModel())
        }
        .environment(\.container, container)
      } else {
        ProgressView("Preparing data...")
          .task {
            await startup()
          }
      }
    }
  }
  
  private func startup() async {
    do {
      try StartupUseCase(userStore: container.userStore, departmentStore: container.departmentStore, roleStore: container.roleStore).execute()
      initialized = true
    } catch {
      print("Startup failed:", error)
      initialized = true
    }
  }
}
