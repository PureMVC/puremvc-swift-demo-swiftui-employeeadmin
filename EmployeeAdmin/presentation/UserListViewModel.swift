//
//  UserListViewModel.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Observation

@Observable
final class UserListViewModel {
  
  private let userData: IUserStore
  
  var users: [User] = []
  var loading: Bool = false
  var error: Error?
  
  init(userStore: IUserStore) {
    self.userData = userStore
  }
  
  func findAll() async {
    loading = true
    defer { loading = false }
    
    do {
      users = try userData.findAll()
    } catch {
      self.error = error
    }
  }
  
  func delete(byID id: Int64) async {
    loading = true
    defer { loading = false }
    
    do {
      try userData.delete(byID: id)
    } catch {
      self.error = error
    }
  }
  
}
