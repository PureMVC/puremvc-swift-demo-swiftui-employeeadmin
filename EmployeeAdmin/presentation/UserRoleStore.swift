//
//  UserRoleStore.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import ComposableArchitecture

@Reducer
struct UserRoleStore {
  
  @ObservableState
  struct State: Equatable {
    var roles: [Role] = []
    var selection: [Role] = []
    var isLoading = false
    var error: String?
  }

  enum Action {
    case findAll
    case findAllResponse(Result<[Role], Error>)
    
    case append(Role)
    case remove(Int)
    
    case findByUserId(id: Int)
    case findbyUserIdResponse(Result<[Role], Error>)
  }
  
  @Dependency(\.roleClient) var client: RoleClient
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .findAll:
        state.isLoading = true
        return .run { send in
          await send(.findAllResponse(Result { try await client.findAll() }))
        }
        
      case let .findAllResponse(.success(roles)):
        state.isLoading = false
        state.roles = roles
        return .none
        
      case let .findAllResponse(.failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        return .none
        
        
      case let .append(role):
        state.selection.append(role)
        return .none
        
      case let .remove(index):
        state.selection.remove(at: index)
        return .none
        
        
      case let .findByUserId(id):
        state.isLoading = true
        return .run { send in
          await send(.findbyUserIdResponse( Result { try await client.findByUserId(id) }))
        }
        
      case let .findbyUserIdResponse(.success(roles)):
        state.isLoading = false
        state.selection = roles
        return .none
        
      case let .findbyUserIdResponse(.failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        return .none
      }
    }
  }
}
