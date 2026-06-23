//
//  UserClient.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import ComposableArchitecture

struct UserClient {
  var findAll: @Sendable() async throws -> [User]
  var findById: @Sendable(_ id: Int) async throws -> User
  var save: @Sendable(_ user: User) async throws -> User
  var update: @Sendable(_ user: User) async throws -> User
  var deleteById: @Sendable(_ id: Int) async throws -> Void
  var findAllDepartments: @Sendable() async throws -> [Department]
}

extension UserClient: DependencyKey {
  static let liveValue: UserClient = {
    let service: IUserService = UserService()
    return UserClient(
      findAll: { try await service.findAll() },
      findById: { try await service.findById($0) },
      save: { try await service.save($0) },
      update: { try await service.update($0) },
      deleteById: { try await service.deleteById($0) },
      findAllDepartments: { try await service.findAllDepartments() }
    )
  }()
}

extension DependencyValues {
  var userClient: UserClient {
    get { self[UserClient.self] }
    set { self[UserClient.self] = newValue }
  }
}
