//
//  UserList.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import ComposableArchitecture

struct UserList: View {
  
  @Bindable var store: StoreOf<UserListStore>
  
  init() {
    self.store = Store(initialState: UserListStore.State()) {
      UserListStore()
    }
  }
  
  var body: some View {
    ZStack {
      users
        .disabled(store.isLoading)
        .blur(radius: store.isLoading ? 2 : 0)
      
      if store.isLoading {
        ProgressView()
          .padding()
          .background(.regularMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 12))
      }
    }
    .navigationTitle("User List")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
          UserForm(id: 0) { user in
            store.send(.addResponse(user))
          }
        } label: {
            Image(systemName: "plus.circle")
                .imageScale(.large)
        }
      }
    }
    .task {
      store.send(.findAll)
    }
    .alert(
        "Error",
        isPresented: .constant(store.error != nil)
    ) {
      Button("OK") {}
    } message: {
      Text(store.error ?? "An unknown error occurred.")
    }
  }
}

extension UserList {
  
  var users: some View {
      List {
        ForEach(store.users) { user in
          NavigationLink(value: user) {
            Text(user.givenName)
          }
        }
        .onDelete { indexSet in
          for index in indexSet {
            let user = store.users[index]
            store.send(.deleteById(id: user.id))
          }
        }
      }
      .navigationDestination(for: User.self) { user in
        UserForm(id: user.id) { user in
          store.send(.updateResponse(user))
        }
      }
  }
  
}

#Preview {
  UserList()
}
