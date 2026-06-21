//
//  DeleteUserUseCase.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation

struct DeleteUserUseCase {
  let repository: IUserRepository

  func callAsFunction(_ id: Int) async throws {
    try await repository.deleteById(id)
  }
}
