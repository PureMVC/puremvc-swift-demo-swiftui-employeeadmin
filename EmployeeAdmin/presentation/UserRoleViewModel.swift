//
//  UserRoleViewModel.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Observation

@Observable
class UserRoleViewModel {
  
  var roles: [Role] = []
  var selection: [Role] = []
  var isLoading = false
  var error: Error?

  private let service: IRoleService
  
  init(service: IRoleService) {
    self.service = service
  }
  
  func findAll() async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      roles = try await service.findAll()
    } catch {
      self.error = error
    }
  }
  
  func findByUserId(_ id: Int) async {
    isLoading = true
    error = nil
    defer { isLoading = false }
    
    do {
      selection = try await service.findByUserId(id)
    } catch {
      self.error = error
    }
  }
}
