//
//  RoleClient.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import ComposableArchitecture

struct RoleClient {
  var findAll: @Sendable() async throws -> [Role]
  var findByUserId: @Sendable (_ id: Int) async throws -> [Role]
}

extension RoleClient: DependencyKey {
  static let liveValue: RoleClient = {
    let service: IRoleService = RoleService()
    return RoleClient(
      findAll: { try await service.findAll() },
      findByUserId: { try await service.findByUserId($0) }
    )
  }()
}

extension DependencyValues {
  var roleClient: RoleClient {
    get { self[RoleClient.self] }
    set { self[RoleClient.self] = newValue }
  }
}
