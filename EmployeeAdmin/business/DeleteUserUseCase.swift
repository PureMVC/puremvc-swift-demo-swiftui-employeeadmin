//
//  DeleteUserUseCase.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation

struct DeleteUserUseCase {
  let service: IUserService

  func callAsFunction(_ id: Int) async throws {
    try await service.deleteById(id)
  }
}
