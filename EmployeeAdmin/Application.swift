//
//  EmployeeAdmin.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import CoreData

@main
struct EmployeeAdmin: App {
  
  let persistence: ApplicationPersistence
  let container: ApplicationContainer
    
  @State private var initialized = false
  
//  func init2() {
//    let arguments = ProcessInfo.processInfo.arguments
//    
//    if arguments.contains("-ui-testing") {
//      let persistence = ApplicationPersistence(inMemory: true)
//      let container = ApplicationContainer(
//        context: persistence.container.viewContext
//      )
//      
//      if arguments.contains("-seed-users") {
//        do {
//          try StartupUseCase(
//            userData: container.userData,
//            departmentData: container.departmentData,
//            roleData: container.roleData
//          ).execute()
//        } catch {
//          fatalError("Unable to seed UI test data: \(error)")
//        }
//      }
//      
//      .container = container
//    } else {
//      self.container = ApplicationContainer(
//        context: ApplicationPersistence.shared.container.viewContext
//      )
//    }
//  }
  
  init() {
    persistence = .shared
    container = ApplicationContainer(context: persistence.container.viewContext)
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
