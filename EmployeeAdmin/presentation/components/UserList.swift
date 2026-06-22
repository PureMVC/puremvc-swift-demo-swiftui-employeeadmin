//
//  UserList.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025-2026 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import SwiftUI
import Observation

struct UserList: View {
  
  @State private var viewModel: UserListViewModel
  
  init() {
    _viewModel = State(initialValue: UserListViewModel(service: container.userService, deleteUser: DeleteUserUseCase(service: container.userService)))
  }
  
  var body: some View {
    ZStack {
      users
        .disabled(viewModel.isLoading)
        .blur(radius: viewModel.isLoading ? 2 : 0)
      
      if viewModel.isLoading {
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
          UserForm { user in
            withAnimation {
              viewModel.users.append(user)
            }
          }
        } label: {
            Image(systemName: "plus.circle")
                .imageScale(.large)
        }
      }
    }
    .navigationDestination(for: User.self) { user in
      UserForm(id: user.id) { user in
        if let index = viewModel.users.firstIndex(where: { $0.id == user.id }) {
          withAnimation {
            viewModel.users[index] = user
          }
        }
      }
    }
    .task {
      if viewModel.users.isEmpty {
        await viewModel.findAll()
      }
    }
    .alert(
        "Error",
        isPresented: Binding(
          get: { viewModel.error != nil },
          set: { _ in viewModel.error = nil }
        )
    ) {
        Button("OK") {
          viewModel.error = nil
        }
    } message: {
        Text(
          (viewModel.error as? Exception)?.message ??
          viewModel.error?.localizedDescription ??
          "An unknown error occurred."
        )
    }
  }
}

extension UserList {
  
  var users: some View {
      List {
        ForEach(viewModel.users) { user in
          NavigationLink(value: user) {
              Text(user.givenName)
          }
        }
        .onDelete { indexes in
          for index in indexes.sorted(by: >) {
            let user = viewModel.users[index]
            withAnimation {
              viewModel.users.remove(at: index)
              return ()
            }
            
            Task {
              await viewModel.deleteById(user.id)
            }
          }
        }
      }
  }
}

#Preview {
  UserList()
}
