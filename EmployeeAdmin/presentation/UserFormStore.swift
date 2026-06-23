//
//  UserFormStore.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import ComposableArchitecture

@Reducer
struct UserFormStore {
  
  @ObservableState
  struct State: Equatable {
    var user: User = .empty
    var departments: [Department] = []
    var isLoading = false
    var error: String?
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    case departments
    case departmentsResponse(Result<[Department], Error>)
    
    case findById(Int)
    case findByIdResponse(Result<User, Error>)
    
    case saveOrUpdate
    case saveOrUpdateResponse(Result<User, Error>)
  }

  @Dependency(\.userClient) var client: UserClient

  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .departments:
        state.isLoading = true
        state.error = nil
        return .run { send in
          await send(.departmentsResponse(Result { try await client.findAllDepartments() }))
        }
        
      case let .departmentsResponse(.success(departments)):
        state.departments = departments
        return .none
        
      case let .departmentsResponse(.failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        return .none
        
      case let .findById(id):
        return .run { send in
          if id == 0 {
            await send(.findByIdResponse(.success(.empty)))
          } else {
            await send(.findByIdResponse(Result { try await client.findById(id) }))
          }
        }
        
      case let .findByIdResponse(.success(user)):
        state.isLoading = false
        state.user = user
        return .none
        
      case let .findByIdResponse(.failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        return .none
        
      case .saveOrUpdate:
        state.isLoading = true
        state.error = nil
        let user = state.user
        return .run { send in
          if user.id == 0 {
            await send(.saveOrUpdateResponse(Result { try await client.save(user) }))
          } else {
            await send(.saveOrUpdateResponse(Result { try await client.update(user) }))
          }
        }
        
      case let .saveOrUpdateResponse(.success(user)):
        state.isLoading = false
        state.user = user
        return .none
        
      case let .saveOrUpdateResponse(.failure(error)):
        state.isLoading = false
        state.error = error.localizedDescription
        return .none
      }
    }
  }

}
