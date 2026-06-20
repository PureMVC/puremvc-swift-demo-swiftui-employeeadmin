//
//  RoleProxy.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation
import Combine
import PureMVC

protocol IRoleProxy: Proxy {
  func findAll() async throws -> [Role]
  func findByUserId(_ id: Int) async throws -> [Role]
}

class RoleProxy: Proxy, IRoleProxy {
    
  override class var NAME: String { "RoleProxy" }
  
  private var session: URLSession
  private var decoder: JSONDecoder
  
  init(session: URLSession, decoder: JSONDecoder) {
    self.session = session
    self.decoder = decoder
    super.init(name: RoleProxy.NAME)
  }
  
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
