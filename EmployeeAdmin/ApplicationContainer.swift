//
//  ApplicationContainer.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import CoreData

@MainActor
final class ApplicationContainer {
  
  let context: NSManagedObjectContext
  let userStore: UserStore
  let departmentStore: DepartmentStore
  let roleStore: RoleStore

  init(context: NSManagedObjectContext) {
    self.context = context
    
    departmentStore = DepartmentStore(context: context)
    roleStore = RoleStore(context: context)
    
    userStore = UserStore(departmentStore: departmentStore, roleStore: roleStore, context: context)
  }
  
  func userList() -> UserList {
    UserList(viewModel: userListViewModel())
  }
  
  private func userListViewModel() -> UserListViewModel {
    UserListViewModel(userStore: userStore)
  }
  
  func userForm(id: Int64) -> UserForm {
    UserForm(id: id, viewModel: userFormViewModel())
  }
  
  private func userFormViewModel() -> UserFormViewModel {
    UserFormViewModel(userStore: userStore, departmentStore: departmentStore)
  }
  
  func userRole(id: Int64, _ selection: [Role]?, _ onComplete: @escaping ([Role]) -> Void) -> UserRole {
    UserRole(id: id, selection, viewModel: userRoleViewModel(), onComplete: onComplete)
  }
  
  private func userRoleViewModel() -> UserRoleViewModel {
    UserRoleViewModel(roleStore: roleStore)
  }
  
}

extension ApplicationContainer {
  
  @MainActor
  static let production: ApplicationContainer = {
    let persistence = ApplicationPersistence.shared
    
    return ApplicationContainer(context: persistence.container.viewContext)
  }()
  
  @MainActor
  static let preview: ApplicationContainer = {
    let persistence = ApplicationPersistence.preview
    
    return ApplicationContainer(context: persistence.container.viewContext)
  }()
  
  static func background() -> ApplicationContainer {
    let persistence = ApplicationPersistence.shared
    
    return ApplicationContainer(context: persistence.backgroundContext())
  }
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
