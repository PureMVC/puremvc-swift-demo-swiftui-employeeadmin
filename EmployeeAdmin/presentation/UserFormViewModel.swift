//
//  UserFormViewModel.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Observation

@Observable
final class UserFormViewModel {
  
  private let userStore: IUserStore
  private let departmentStore: IDepartmentStore

  var user: User
  var departments: [Department] = []
  var loading: Bool = false
  var error: Error?
  
  init (userStore: IUserStore, departmentStore: IDepartmentStore) {
    self.userStore = userStore
    self.departmentStore = departmentStore
    user = .empty
  }
  
  func find(byId id: Int64) async {
    loading = true
    defer { loading = false }
    
    do {
      guard let user = try userStore.find(byID: id) else { return }
      
      try userStore.delete(self.user)
      self.user = user
    } catch {
      self.error = error
    }
  }
  
  func save(selection roles: [Role]?) async {
    loading = true
    defer { loading = false }
    
    do {
      user.roles = roles ?? []
      user = try userStore.save(user)
    } catch {
      self.error = error
    }
  }
  
  func findAllDepartments() async {
    loading = true
    defer { loading = false }
    
    do {
      departments = try departmentStore.findAll()
    } catch {
      self.error = error
    }
  }
  
}
