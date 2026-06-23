//
//  UserListStore.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import ComposableArchitecture

@Reducer
struct UserListStore {
  
  @ObservableState
  struct State: Equatable {
    var users: [User] = []
    var isLoading = false
    var error: String?
  }
  
  enum Action {
    case findAll
    case findAllResponse(Result<[User], Error>)
    
    case updateResponse(User)
    
    case deleteById(id: Int)
    case deleteByIdResponse(id: User.ID, Result<Void, Error>)
  }
  
  @Dependency(\.userClient) var client: UserClient
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .findAll:
        state.isLoading = true
        return .run { send in
          await send(.findAllResponse(Result { try await client.findAll() }))
        }
        
      case let .findAllResponse(.success(users)):
        state.isLoading = false
        state.users = users
        return .none
        
      case let .findAllResponse(.failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        return .none

        
      case let .updateResponse(user):
        guard let index = state.users.firstIndex(where: { $0.id == user.id }) else {
          return .none
        }
        
        state.users[index] = user
        return .none
        
      case let .deleteById(id):
        state.isLoading = true
        return .run { send in
          await send(.deleteByIdResponse(id: id, Result { try await client.deleteById(id) }))
        }
        
      case let .deleteByIdResponse(id, .success):
        state.isLoading = false
        state.users.removeAll { $0.id == id }
        return .none
        
      case let .deleteByIdResponse(_, .failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        return .none
      }
    }
  }
  
}
