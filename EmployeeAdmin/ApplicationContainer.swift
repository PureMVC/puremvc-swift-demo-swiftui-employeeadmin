//
//  ApplicationContainer.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import RealmSwift

final class ApplicationContainer {
  
  let configuration: Realm.Configuration
  let realm: Realm
  let userStore: UserStore
  let departmentStore: DepartmentStore
  let roleStore: RoleStore

  init(configuration: Realm.Configuration) {
    self.configuration = configuration
    self.realm = try! Realm(configuration: configuration)
    departmentStore = DepartmentStore(configuration: configuration)
    roleStore = RoleStore(configuration: configuration)
    userStore = UserStore(departmentStore: departmentStore, roleStore: roleStore, configuration: configuration)
  }
  
  func userListViewModel() -> UserListViewModel {
    UserListViewModel(userStore: userStore)
  }
  
  func userFormViewModel() -> UserFormViewModel {
    UserFormViewModel(userStore: userStore, departmentStore: departmentStore)
  }
  
  func userRoleViewModel() -> UserRoleViewModel {
    UserRoleViewModel(roleStore: roleStore)
  }
  
}

extension ApplicationContainer {
  
  @MainActor
  static let preview: ApplicationContainer = {
    let persistence = ApplicationPersistence.preview
    
    return ApplicationContainer(
      configuration: persistence.configuration
    )
  }()
}

private struct ApplicationContainerKey: EnvironmentKey {
  static let defaultValue: ApplicationContainer? = nil
}

extension EnvironmentValues {
  var container: ApplicationContainer? {
    get { self[ApplicationContainerKey.self] }
    set { self[ApplicationContainerKey.self] = newValue }
  }
}
