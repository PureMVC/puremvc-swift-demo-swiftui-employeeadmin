//
//  UserListViewModel.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Observation

@Observable
final class UserListViewModel {
  
  var users: [User] = []
  var error: Error?
  var isLoading = false
  
  private let service: IUserService
  private let deleteUser: DeleteUserUseCase
  
  init(service: IUserService, deleteUser: DeleteUserUseCase) {
    self.service = service
    self.deleteUser = deleteUser
  }
  
  func findAll() async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      users = try await service.findAll()
    } catch {
      self.error = error
    }
  }
  
  func deleteById(_ id: Int) async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      try await deleteUser(id)
    } catch {
      self.error = error
    }
  }
}
