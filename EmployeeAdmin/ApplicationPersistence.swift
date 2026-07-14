//
//  Persistence.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import CoreData

struct ApplicationPersistence {
  static let shared = ApplicationPersistence()
  
  @MainActor
  static let preview: ApplicationPersistence = {
    let result = ApplicationPersistence(inMemory: true)
    let viewContext = result.container.viewContext
    let container = ApplicationContainer(context: viewContext)
    do {
      try StartupUseCase(userStore: container.userStore, departmentStore: container.departmentStore, roleStore: container.roleStore).execute()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    
    return result
  }()
  
  let container: NSPersistentContainer

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "EmployeeAdmin")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores { [container] _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
      
      if let _ = container.persistentStoreCoordinator.persistentStores.first?.url {
//        print(url.path)
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}
