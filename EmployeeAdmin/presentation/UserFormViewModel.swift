//
//  UserFormViewModel.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Observation

@Observable
class UserFormViewModel {
  
  var departments: [Department] = []
  var user: User = .empty
  var isLoading = false
  var error: Error?
  
  private let repository: IUserRepository
  
  init(repository: IUserRepository) {
    self.repository = repository
  }

  func findAllDepartments() async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      departments = try await repository.findAllDepartments()
    } catch {
      self.error = error
    }
  }
  
  func findById(_ id: Int) async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      user = try await repository.findById(id)
    } catch {
      self.error = error
    }
  }
  
  func saveOrUpdate(_ user: User) async {
    do {
      if (user.id == 0) {
        self.user = try await repository.save(user)
      } else {
        self.user = try await repository.update(user)
      }
    } catch {
      self.error = error
    }
  }

}
