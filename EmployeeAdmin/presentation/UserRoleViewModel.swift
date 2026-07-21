//
//  UserRoleViewModel.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Observation

@MainActor
@Observable
final class UserRoleViewModel {
  
  private let roleData: IRoleStore
  
  var roles: [Role] = []
  var selection: [Role] = []
  var loading: Bool = false
  var error: Error?
  
  init(roleStore: IRoleStore) {
    self.roleData = roleStore
  }
  
  func findAll() async {
    loading = true
    defer { loading = false }
    
    do {
      roles = try roleData.findAll()
    } catch {
      self.error = error
    }
  }
  
  func find(byUserID id: Int64) async {
    loading = true
    defer { loading = false }
    
    do {
      selection = try roleData.find(byUserID: id)
    } catch {
      self.error = error
    }
  }
  
}
