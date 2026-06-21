//
//  UserRepository.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import Foundation
import Combine

protocol IUserRepository {
  func findAll() async throws -> [User]
  func findById(_ id: Int) async throws -> User
  func save(_ user: User) async throws -> User
  func update(_ user: User) async throws -> User
  func deleteById(_ id: Int) async throws -> Void
  func findAllDepartments() async throws -> [Department]
}

final class UserRepository: IUserRepository {
  
  private let session: URLSession = .shared
  private let encoder: JSONEncoder = JSONEncoder()
  private let decoder: JSONDecoder = JSONDecoder()
  
  func findAll() async throws -> [User] {
    var request = URLRequest(url: URL(string: "http://localhost/users")!)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let (data, response) = try await session.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw try decoder.decode(Exception.self, from: data)
    }
    
    return try decoder.decode([User].self, from: data)
  }
  
  func findById(_ id: Int) async throws -> User {
    var request = URLRequest(url: URL(string: "http://localhost/users/\(id)")!)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let (data, response) = try await session.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw try decoder.decode(Exception.self, from: data)
    }
    
    return try decoder.decode(User.self, from: data)
  }
  
  func save(_ user: User) async throws -> User {
    var request = URLRequest(url: URL(string: "http://localhost/users")!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    request.httpBody = try? encoder.encode(user)
    
    let (data, response) = try await session.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 201 else {
      throw try decoder.decode(Exception.self, from: data)
    }
    
    return try decoder.decode(User.self, from: data)
  }
  
  func update(_ user: User) async throws -> User {
    var request = URLRequest(url: URL(string: "http://localhost/users")!)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    request.httpBody = try? encoder.encode(user)
    
    let (data, response) = try await session.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw try decoder.decode(Exception.self, from: data)
    }
    
    return try decoder.decode(User.self, from: data)
  }
    
  func deleteById(_ id: Int) async throws -> Void {
    var request = URLRequest(url: URL(string: "http://localhost/users/\(id)")!)
    request.httpMethod = "DELETE"
    
    let (data, response) = try await session.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 204 else {
      throw try decoder.decode(Exception.self, from: data)
    }
  }
    
  func findAllDepartments() async throws -> [Department] {
    var request = URLRequest(url: URL(string: "http://localhost/departments")!)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let (data, response) = try await session.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw try decoder.decode(Exception.self, from: data)
    }
    
    return try decoder.decode([Department].self, from: data)
  }
    
}
