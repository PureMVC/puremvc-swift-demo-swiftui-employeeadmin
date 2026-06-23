//
//  DeleteUserUseCase.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import ComposableArchitecture

struct DeleteUserUseCase {
  var execute: @Sendable (_ id: Int) async throws -> Void

  func callAsFunction(_ id: Int) async throws {
    try await execute(id)
  }
}

extension DeleteUserUseCase: DependencyKey {
  static let liveValue: DeleteUserUseCase = {
    let service: IUserService = UserService()

    return DeleteUserUseCase(
      execute: { try await service.deleteById($0) }
    )
  }()
}

extension DependencyValues {
  var deleteUser: DeleteUserUseCase {
    get { self[DeleteUserUseCase.self] }
    set { self[DeleteUserUseCase.self] = newValue }
  }
}
