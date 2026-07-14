//
//  Persistence.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import RealmSwift

struct ApplicationPersistence {
  static let shared = {
    do {
      return try ApplicationPersistence()
    } catch {
      fatalError("Failed to initialize Realm: \(error)")
    }
  }()
  
  @MainActor
  static let preview: ApplicationPersistence = {
    do {
      let persistence = try ApplicationPersistence(inMemory: true)
      let container = ApplicationContainer(configuration: persistence.configuration)
      
      try StartupUseCase(userStore: container.userStore, departmentStore: container.departmentStore, roleStore: container.roleStore).execute()
      
      return persistence
    } catch {
      fatalError("Failed to initialize preview Realm: \(error)")
    }
  }()
  
  let configuration: Realm.Configuration
  
  // Keeps the in-memory Realm alive.
  private let realm: Realm?

  init(inMemory: Bool = false) throws {
    let types: [Object.Type] = [UserRealmObject.self, DepartmentRealmObject.self, RoleRealmObject.self]
    
    if inMemory {
      configuration = Realm.Configuration(inMemoryIdentifier: "EmployeeAdmin", objectTypes: types)
      realm = try Realm(configuration: configuration)
    } else {
      configuration = Realm.Configuration(schemaVersion: 1, objectTypes: types)
      realm = nil
    }

//    if let _ = container.persistentStoreCoordinator.persistentStores.first?.url {
      //        print(url.path)
//    }
  }
}
