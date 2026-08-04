//
//  RoleRepository.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation

protocol IRoleService {
  func findAll() async throws -> [Role]
  func findByUserId(_ id: Int) async throws -> [Role]
}
