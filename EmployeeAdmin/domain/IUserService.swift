//
//  UserRepository.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation

protocol IUserService {
  func findAll() async throws -> [User]
  func findById(_ id: Int) async throws -> User
  func save(_ user: User) async throws -> User
  func update(_ user: User) async throws -> User
  func deleteById(_ id: Int) async throws -> Void
  func findAllDepartments() async throws -> [Department]
}
