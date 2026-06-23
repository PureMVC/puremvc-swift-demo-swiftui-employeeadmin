//
//  RoleService.swift
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

final class RoleService: IRoleService {
  
  private let session: URLSession = .shared
  private let decoder: JSONDecoder = JSONDecoder()
  
  func findAll() async throws -> [Role] {
    var request = URLRequest(url: URL(string: "http://localhost/roles")!)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let (data, response) = try await session.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw try decoder.decode(Exception.self, from: data)
    }
    
    return try decoder.decode([Role].self, from: data)
  }
  
  func findByUserId(_ id: Int) async throws -> [Role] {
    var request = URLRequest(url: URL(string: "http://localhost/users/\(id)/roles")!)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let (data, response) = try await session.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw try decoder.decode(Exception.self, from: data)
    }
    
    return try decoder.decode([Role].self, from: data)
  }
    
}
